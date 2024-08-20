function [E,psi,psip]=Schroed2D_PWE_f(x,y,V0,Mass,Nx,Ny,NGx,NGy,EF,T,EF_range)
% x,y: linspace coordinate; V0: total potential; Nx, Ny: coordinate grids; NGx, NGy: kspace grids; EF: Fermi Energy (J)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h    = 6.62606896E-34;               %% Planck constant [J.s]

dE   = EF_range*kB*T;                         %% solve the eigen energy in EF±dE

n_init = 30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Interpolation on a grid that have 2^N points %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NGx = 2*floor(NGx/2);           %% round to lower even number
NGy = 2*floor(NGy/2);           %% round to lower even number

[X,Y] = meshgrid(x,y);
xx=linspace(x(1),x(end),Nx);
yy=linspace(y(1),y(end),Ny);
[XX,YY] = meshgrid(xx,yy);

V=interp2(X,Y,V0,XX,YY);

dx=x(2)-x(1);
dxx=xx(2)-xx(1);
dy=y(2)-y(1);
dyy=yy(2)-yy(1);
Ltotx=xx(end)-xx(1);
Ltoty=yy(end)-yy(1);

[XX,YY] = meshgrid(xx,yy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Building of the potential in Fourier space %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vk = fftshift(fft2(V))*dxx*dyy/Ltotx/Ltoty;

Vk = Vk(Ny/2-NGy+1:Ny/2+NGy+1 , Nx/2-NGx+1:Nx/2+NGx+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Reciprocal lattice vectors %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gx = (-NGx/2:NGx/2)'*2*pi/Ltotx;
Gy = (-NGy/2:NGy/2)'*2*pi/Ltoty;

NGx=length(Gx);
NGy=length(Gy);
NG=NGx*NGy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Building Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx_x = repmat((1:NGx), [NGy 1 ]);
idx_x = idx_x(:);

idx_y = repmat((1:NGy)', [1 NGx]);
idx_y = idx_y(:);

%idx_X = (idx_x-idx_x') + NGx;      %% work only in Octave
%idx_Y = (idx_y-idx_y') + NGy;      %% work only in Octave
idx_X = (repmat(idx_x,[1 NG])-repmat(idx_x',[NG 1])) + NGx;     %% work in Octave and Matlab
idx_Y = (repmat(idx_y,[1 NG])-repmat(idx_y',[NG 1])) + NGy;     %% work in Octave and Matlab

idx = sub2ind(size(Vk), idx_Y(:), idx_X(:));
idx = reshape(idx, [NG NG]);

GX = diag(Gx(idx_x));
GY = diag(Gy(idx_y));

D2 = GX.^2 + GY.^2 ;

H =  hbar^2/(2*Mass)*D2  +  Vk(idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Solving Hamiltonian %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = sparse(H);
size(H)

% EF is Fermi Energy
EF_matrix = eye(size(H)) * EF;

H = H - EF_matrix;

% using n_init to solve the bound state
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

psi = zeros(size(X, 1), size(X, 2), n);

psip = psi;

for i=1:n
    PSI = reshape(psik(:,i),[NGy,NGx]);
    PSI = invFFT2D(PSI,Ny,Nx)/(dxx*dyy) ;
    psi_temp = interp2(XX,YY,PSI,X,Y);
    psi(:,:,i) = psi_temp / sqrt( trapz( y' , trapz(x,abs(psi_temp).^2 ,2) , 1 )  );  % normalisation of the wave function psi
    norm1 = sum(sum(conj(psi(:,:,i)).*psi(:,:,i)));
    psi(:,:,i) = psi(:,:,i)/sqrt(norm1);
    psip(:,:,i) = fft2(psi(:,:,i));
    norm2 = sum(sum(conj(psip(:,:,i)).*psip(:,:,i)));
    psip(:,:,i) = psip(:,:,i)/sqrt(norm2);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Vxy] = invFFT2D(Vk2D,Ny,Nx)

    Nkx=length(Vk2D(1,:));
    Nky=length(Vk2D(:,1));
    
    Nx1=Nx/2-floor(Nkx/2);
    Nx2=Nx/2+ceil(Nkx/2);
    Ny1=Ny/2-floor(Nky/2);
    Ny2=Ny/2+ceil(Nky/2);
    
    Vk2D00=zeros(Ny,Nx);
    Vk2D00( Ny1+1:Ny2 , Nx1+1:Nx2)=Vk2D;
    Vxy=ifft2(ifftshift(Vk2D00));

end
