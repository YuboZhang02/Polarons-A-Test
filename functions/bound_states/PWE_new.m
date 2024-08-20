function [E,psi,psip]=PWE_new(ss)
% x,y: linspace coordinate; V0: total potential; Nx, Ny: coordinate grids; NGx, NGy: kspace grids; EF: Fermi Energy (J)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dE   = ss.EF_range*kB*ss.T;                         %% solve the eigen energy in EF±dE

n_init = 30;

N = ss.Nx*ss.Ny;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Building Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_q = ss.g_q.*ss.alpha_0;          % Deformation potential induced hopping
K = band_structure(ss);            % Electron band energy

idx_x = repmat((1:ss.Nx), [ss.Ny, 1]);
idx_x = idx_x(:);                  % x-index

idx_y = repmat((1:ss.Ny)', [1,ss.Nx]);
idx_y = idx_y(:);                  % y-index

idx_X = mod((repmat(idx_x,[1, N])-repmat(idx_x',[N, 1])), ss.Nx)+1;     
idx_Y = mod((repmat(idx_y,[1, N])-repmat(idx_y',[N, 1])), ss.Ny)+1;     % Hopping index

idx = sub2ind([ss.Ny,ss.Nx], idx_Y(:), idx_X(:));
idx = reshape(idx, [N, N]);

V = V_q(idx);

H =  diag(K(:))  +  V + V';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Solving Hamiltonian %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = sparse(H);

% EF is Fermi Energy
EF_matrix = eye(size(H)) * ss.EF;
% 
H = H - EF_matrix;

% using n_init to solve the bound state
% opts = struct('SubspaceDimension', 50);
[psik_init, Ek_init] = eigs(H, n_init, 'smallestabs');
maxEigenvalueAbs_init = abs(Ek_init(end, end)); % get the max eigval

% make a new estimate of n
estimatedN = n_init * (dE / maxEigenvalueAbs_init);

if estimatedN > n_init
    n = ceil(estimatedN); % update
    % display(n)
    [psik, Ek] = eigs(H, n, 'smallestabs');
else
    psik = psik_init;
    Ek = Ek_init;
    n = n_init;
end

E = diag(Ek);

E = real(E);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Transforming & Scaling the waves functions %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psi = zeros(ss.Ny, ss.Nx, n);

psip = psi;

for i=1:n
    tmp_psip = reshape(psik(:,i),[ss.Ny,ss.Nx]);
    norm = sqrt(sum(sum(conj(tmp_psip).*tmp_psip)));
    psip(:,:,i) = tmp_psip/norm;
    psi(:,:,i) = ifft2(psip(:,:,i))*sqrt(N);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sorting eigenstates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[E_sorted, index] = sort(E);
psi_sorted = psi(:,:,index);
psip_sorted = psip(:,:,index);

E = E_sorted;
psi = psi_sorted;
psip = psip_sorted;

end

