function ss = setup(s)

ss = s;

% Fixed parameters that are not suggested to change

% ==================== Do not change below! =============================

%% 2-body transform
if s.two_body
    ss.meff    = 2*ss.meff;
    ss.Lx      = 0.5*ss.Lx;
    ss.Ly      = 0.5*ss.Ly;
    ss.x0      = 0.5*ss.x0;
    ss.y0      = 0.5*ss.y0;
    ss.qs      = 2*ss.qs;
    ss.sigma_x = 0.5*ss.sigma_x;
    ss.sigma_y = 0.5*ss.sigma_y;
end


%% Derived Parameters

ss.Lx      = ss.Lx*1e-9;    % box x-width (m)
ss.Ly      = ss.Ly*1e-9;    % box y-width (m)
ss.tau     = ss.tau*1e-15;  % simulation timestep (s)
ss.toltime = ss.N*ss.tau;      % total simulation time (s)
ss.x0      = ss.x0*ss.Lx;      % initial location of wave packet (m)
ss.y0      = ss.y0*ss.Ly;      % initial location of wave packet (m)
ss.sigma_x = ss.sigma_x*ss.Lx; % width of wave packet in x-direction (m)
ss.sigma_y = ss.sigma_y*ss.Ly; % width of wave packet in y-direction (m)
ss.delx    = ss.Lx/(2*ss.nx);  % x grid spacing (m)
ss.dely    = ss.Ly/(2*ss.ny);  % y grid spacing (m)
ss.delkx   = 2*pi/ss.Lx;    % kx-sampling resolution ~ 10^8 (m^-1)
ss.delky   = 2*pi/ss.Ly;    % ky-sampling resolution ~ 10^8 (m^-1)
ss.a       = ss.a*1e-9;     % lattice parameter (m)
ss.pd      = ss.pd*1e-9;    % distance btw CuO2 planes (m)
ss.mass    = ss.meff*me;    % effective electron mass (kg)
ss.Ed      = ss.Ed*e;       % Deformation potential constant (J)
ss.EF      = ss.EF*e;       % Fermi energy (J)
ss.rho     = ss.rho*1e3;    % mass density (kg/m^3)
ss.Nx      = 2*ss.nx+1;     % x grid size
ss.Ny      = 2*ss.ny+1;     % y grid size
ss.t1      = ss.t1*e;
ss.t2      = ss.t2*e;

ss.Vol   = ss.pd*ss.Lx*ss.Ly;          % total volume
ss.qD    = pi/ss.a;                 % Debye cutoff
ss.qBlur = ss.qD*(1-ss.blur);       % blur cutoff
ss.kF    = ss.qs*ss.qD/2;           % initial momentum
ss.A     = ss.Ed*sqrt(hbar/ ...
      (2*ss.vs*ss.rho*ss.Vol));   % e-ph coupling strength V_q divided 
                         % by (q/\sqrt{omega/vs})
% % ======================================================================
% % 7.Display Parameters
% % ======================================================================
% if ss.dynamic
%     strDynamic = 'on';
% else
%     strDynamic = 'off';
% end
% 
% if back_action
%     strback_action = 'on';
% else
%     strback_action = 'off';
% end
% 
% strtau = num2str(tau);
% strE = num2str(E);
% strT = num2str(T);
% strB = num2str(B);

%% Create meshgrid of coordinate and wavevector space
[ss.x,ss.y] = meshgrid(-ss.Lx/2:ss.delx:ss.Lx/2,-ss.Ly/2:ss.dely:ss.Ly/2);
[ss.kx,ss.ky] = meshgrid([0:ss.delkx:ss.nx*ss.delkx,-ss.nx*ss.delkx:ss.delkx:(-ss.delkx)], ...
          [0:ss.delky:ss.ny*ss.delky,-ss.ny*ss.delky:ss.delky:(-ss.delky)]);


%% Create initialized electron wave packet
ss.psi_0 = init_wavefunc(ss);


%% Create initialized deformation potential

q          = zeros(ss.Ny,ss.Nx); % q(iy,ix) is norm of wavevector at (ix,iy)
qx         = zeros(ss.Ny,ss.Nx); % value of wavevector x-component at (ix,iy)
qy         = zeros(ss.Ny,ss.Nx); % value of wavevector y-component at (ix,iy)
ss.range_q = zeros(ss.Ny,ss.Nx); % range of possible q (marked with 1)

% set q and its range
for i=1:ss.Ny
    for j=1:ss.Nx
        qx_tmp = [(j-1)*ss.delkx, (j-1)*ss.delkx, (j-1-ss.Nx)*ss.delkx, (j-1-ss.Nx)*ss.delkx];
        qy_tmp = [(i-1)*ss.delky, (i-1-ss.Ny)*ss.delky, (i-1)*ss.delky, (i-1-ss.Ny)*ss.delky];
        
        q_tmp = sqrt(qx_tmp.^2 + qy_tmp.^2);
        
        [q_min, idx] = min(q_tmp);
        
        if q_min < ss.qD
            q(i,j) = q_min;
            qx(i,j) = qx_tmp(idx);
            qy(i,j) = qy_tmp(idx);
        end

        
        if q_min < ss.qBlur
            ss.range_q(i,j) = 1;
        end
    end
end

ss.range_q(1,1) = 0; % no DC component

ss.omega     = dispersion_relation(ss.dspr_type,qx,qy,ss.vs,ss.a); % ω(qx,qy),input dispersion relation type first (Linear,Acoustic,Optic)

ss.occ_num    = (1./(exp(hbar*ss.omega/(kB*ss.T))-1));     % Boson distribution
ss.occ_num(isinf(ss.occ_num)) = 0;                            % remove infinity

ss.g_q        = (ss.A*q./sqrt(ss.omega/ss.vs));         % electron-phonon coupling strength
ss.g_q(isnan(ss.g_q))         = 0;                      % remove NaN

rng(ss.seed)
rand_phase = rand(ss.Ny,ss.Nx)*2*pi;                        % (rng) uncorrelated random phase for different modes
ss.alpha_0 = sqrt(ss.occ_num).*exp(1i*rand_phase);       % coherent state eigenval

tmp_FT_V = ss.Nx*ss.Ny*2*ss.g_q.*ss.alpha_0;       % Fourier Transformation of deformation potential

% V is deformation potential
if ss.two_body
   tmp_V = 2*real(ifft2(real(tmp_FT_V)));   % 2body deformation potential in the real space
else
   tmp_V = real(ifft2(tmp_FT_V));           % 1body deformation potential in the real space
end


%% add lattice potential
electric_potential = e*ss.E*ss.x;                    % electric potentials

if ss.lattice_strength == 0
    ss.phi = electric_potential;
else
    ss.phi = electric_potential+...
        lattice_potential(ss.x,ss.y,ss.Lx,ss.Ly,e,ss.lattice_number,ss.lattice_strength); % all the other potential
end

ss.U_0 = tmp_V+ss.phi;

end
