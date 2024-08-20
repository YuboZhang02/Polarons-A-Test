% designed for moving polarons

% simulate the propagation using split operator method
function r = propagate(ss)


%% Memory allocations

r.Ave_xy    = zeros(2, ss.N);  % averaged coordinate at each step
r.Ave_kxky  = zeros(2, ss.N);  % averaged momentum at each step
r.Msd       = zeros(1, ss.N);  % Mean square distance
r.tcorrPsi  = zeros(1, ss.N);  % propagated wave function prod with that in free space |<psi(t)|psi_free(t)>|
r.tcorrPsi0 = zeros(1, ss.N);  % time correlation func of wave function |<psi(t)|psi(0)>|
r.tcorrU    = zeros(1, ss.N);  % time correlation func of whole potential U
r.Energy    = zeros(1, ss.N);  % hamiltonian of the system during the simulation
r.elec_Ek   = zeros(1, ss.N);  % kinetic energy of electron
r.elec_Ep   = zeros(1, ss.N);  % potential energy of electron
r.vibr_E    = zeros(1, ss.N);  % energy of vibrons

r.alpha = ss.alpha_0;
r.psi   = ss.psi_0;

if ss.save_all_time
    Nsave = round(ss.N/ss.save_interval);
    r.alltime_psi = zeros(ss.Nx,ss.Ny,Nsave); % wavefunction at each step
    r.alltime_U   = zeros(ss.Nx,ss.Ny,Nsave); % potential at each step
    iter_save = 1;
end

if ss.save_video
    videoName = strcat(ss.fileName,'.avi');
    % Create a VideoWriter object and set the frame rate
    r.outputVideo = VideoWriter(videoName);  % creates a Motion JPEG AVI file  % creates an MPEG-4 file
    r.outputVideo.FrameRate = 4;
    open(r.outputVideo);
end

tcorrU_0 = sum(sum(ss.U_0.*ss.U_0));  % correlation of U at t=0, for normalization


%% set electron band energy
K = band_structure(ss);

% % redefine coordinate for plotting
% [kx1,ky1] = meshgrid([-nx*delkx:delkx:(-delkx), 0:delkx:nx*delkx], ...
%                    [-ny*delky:delky:(-delky), 0:delky:ny*delky]);
% 
% % adjust the K
% K1 = K([nx+1:end, 1:nx], [ny+1:end, 1:ny]);
% figure
% contourf(kx1(1,:), ky1(:,1), K1'/e);
% colorbar;
% xlabel('kx(m^{-1})');
% ylabel('ky(m^{-1})');
% title('Band Energy of Electron (eV)');
% 
% figure
% contourf(kx1(1,:), ky1(:,1), log(abs(K1'/e-omega1'.*(hbar/e))));
% colorbar;
% xlabel('kx(m^{-1})');
% ylabel('ky(m^{-1})');
% title('Abs Energy difference btw phonon and electron (eV)');

%% initialize split operator and symplectic coefficients

kvec = exp(-1i*K*ss.tau/hbar);          % Forward kinetic split propagator
half_kvec = exp(-1i*K/2*ss.tau/hbar);   % half step kinetic split propagator


%% Add s-wave scatters(polarons) in random spaces

%polaron_potential_shape = 'bessel_function';
%polaron_number = 3;
%polaron_potential_height = 10^(-20);

H_xy   = ss.phi+e^2*ss.B^2*ss.x.^2/(2*ss.mass) + polarons_setup(ss);      % potential energy in coordinate space without deformation potential
H_xky  = -hbar*e*ss.B*ss.x.*ss.ky/ss.mass;            % Magnetic potential energy in both x&ky space
xkyvec = exp(-1i*H_xky/2*ss.tau/hbar);       % magnetic split propagator

% tic

psi_k = fft2(ss.psi_0);
free_psip = psi_k/sqrt(ss.Nx*ss.Ny);

% Initialize a matrix to hold the cumulative sum of abs(psi_p)^2 over all time steps.
% This matrix should have the same dimensions as psi_p.
r.cumulativeSumMatrix = zeros(ss.Nx, ss.Ny); % Assuming psi_p is Nx by Ny


% we use symplectic Euler for equation of motion
% coefficient of integrater, we suggest SymplecticEuler

% method = 'SymplecticEuler';
% switch method
%     case 'OriginalEuler'
%         b1 = 1;   b2 = 0;   b3 = 0;
%     case 'SymplecticEuler'
%         b1 = 0;   b2 = 0;   b3 = 1;
%     case '2ndRungeKutta'
%         b1 = 0;   b2 = 1;   b3 = 0;
%     case '4thRungeKutta'
%         b1 = 1/6; b2 = 2/3; b3 = 1/6;
%     case 'Symplectic4thRK'
%         b1 = 1/(2*(2-2^(1/3)));
%         b2 = (1-2^(1/3))/(2-2^(1/3));
%         b3 = 1/(2*(2-2^(1/3)));
%     otherwise
%         error('Unknown integrator');
% end


%% set the plotting figure
mainFig = [];

if ss.real_time_fig
    mainFig.fig = figure;
    % Get the position and size of each monitor
    monitors = get(0, 'MonitorPositions');
    
    % Choose the 2 or other display monitor
    monitor = monitors(1, :);
    
    % Calculate the position of the left and bottom edges
    mainFig.Left   = monitor(1);
    mainFig.Bottom = monitor(2);
    mainFig.Length = monitor(3);
    mainFig.Width  = monitor(4);
    
    if ss.save_video
        % Set the position and size of the figure
        set(mainFig.fig, 'Position', [mainFig.Left mainFig.Bottom mainFig.Length mainFig.Length/2]);
    else
        set(mainFig.fig, 'Position', [mainFig.Left mainFig.Bottom mainFig.Length mainFig.Width]);
    end
end


%% the loop of split-operator algorithm

for iter=1:ss.N
    
    FT_V = ss.Nx*ss.Ny*2*ss.g_q.*r.alpha;          % Fourier Transformation of deformation potential
        
    if ss.two_body
        V = 2*real(ifft2(real(FT_V)));                   % deformation potential in the real space (two body)
        if ss.blur>0 && ss.blur<1
            Vblur = 2*real(ifft2(real(ss.range_q.*FT_V)));   % blured deformation potential in the real space (two body)
        end
    else
        V = real(ifft2(FT_V));                           % deformation potential in the real space (one body)
        if ss.blur>0 && ss.blur<1
            Vblur = real(ifft2(ss.range_q.*FT_V));           % blured deformation potential in the real space (one body)
        end
    end
    
    %% equation of motion
    
    H_xy   = ss.phi+e^2*ss.B^2*ss.x.^2/(2*ss.mass) + polarons_move(ss,iter);  % time-dependent polarons

    init_psi  = r.psi;
    r.U       = V+H_xy;                           % total potential
    if ss.blur>0 && ss.blur<1
        r.Ublur   = Vblur+H_xy;                       % blured total potential
    end
    half_xvec = exp(-1j*r.U/2*ss.tau/hbar);       % Potential split propagator
    
    if ss.B==0
        psi_k     = fft2(half_xvec.*init_psi);
        half_psik = half_kvec.*psi_k;           % motion of the electron (half step)
        r.psi       = half_xvec.*ifft2(half_kvec.*half_psik);
        half_psi  = ifft2(half_psik);
    else
        psi_k     = fft(xkyvec.*fft(half_xvec.*r.psi),[],2);
        half_psik = half_kvec.*psi_k;
        r.psi       = half_xvec.*ifft(xkyvec.*ifft(half_kvec.*half_psik,[],2));
        half_psi  = ifft2(half_psik);
    end
    
    % The Fourier transformed electron probability density
    b1=0;b2=0;b3=1;
    if ss.two_body
        density_fft = 2.*real(fft2(b1*init_psi.*conj(init_psi) + b2*half_psi.*conj(half_psi) + b3*r.psi.*conj(r.psi))); 
    else
        density_fft = fft2(b1*init_psi.*conj(init_psi) + b2*half_psi.*conj(half_psi) + b3*r.psi.*conj(r.psi)); 
    end
    
    % motion of lattice vibration
    r.alpha = exp(-1i*double(ss.dynamic)*ss.tau*ss.omega).*r.alpha;
    r.alpha = r.alpha-double(ss.dynamic)*1i*ss.tau*...
            (double(ss.back_action)*ss.g_q.*density_fft/hbar); 

    % [psi, alpha, U, V] = split_operator(psi, alpha, Nx, Ny, two_body, g_q, H_xy, tau, hbar, B, half_kvec, xkyvec, dynamic, omega, back_action);

    %% data processing

    r.psi_p = fft2(r.psi)/sqrt(ss.Nx*ss.Ny);      % wavefunction in k-space

    % Sum all psi_p squared here! here and then display at end the s
    r.cumulativeSumMatrix = r.cumulativeSumMatrix + abs(r.psi_p).^2; %Probability density of wf in k space summed over time


    r.Ave_xy(:,iter)   = [real(sum(sum(conj(r.psi).*ss.x.*r.psi))),...
                        real(sum(sum(conj(r.psi).*ss.y.*r.psi)))]; % average position
    r.Ave_kxky(:,iter) = [real(sum(sum(conj(r.psi_p).*ss.kx.*r.psi_p))),...
                        real(sum(sum(conj(r.psi_p).*ss.ky.*r.psi_p)))]; %average momentum
    r.Msd(iter)        = real(sum(sum(conj(r.psi).*((ss.x-r.Ave_xy(1,iter)).^2 ...
                        +(ss.y-r.Ave_xy(2,iter)).^2).*r.psi))); % mean square distance 2
    
    r.elec_Ek(iter)    = real(sum(sum(conj(r.psi_p).*K.*r.psi_p))); % electron kinetic E
    r.elec_Ep(iter)    = real(sum(sum(conj(r.psi).*r.U.*r.psi)));         % electron potential E
    r.vibr_E(iter)     = hbar*real(sum(sum(ss.omega.*abs(r.alpha).^2)));      % vibron E
    r.Energy(iter)     = r.elec_Ep(iter)+r.elec_Ek(iter)+r.vibr_E(iter);  % whole energy 
    r.tcorrU(iter)     = sum(sum(r.U.*ss.U_0))/tcorrU_0;               % t-correlation of U
    r.tcorrPsi0(iter)  = abs(sum(sum(conj(ss.psi_0).*r.psi)));
    
    if ss.save_all_time && mod(iter,ss.save_interval)==1
        r.alltime_psi(:,:,iter_save) = r.psi; % save wavefunction at each step
        r.alltime_U(:,:,iter_save)   = r.U;   % save potential at each step
        iter_save = iter_save+1;
    end
    
    % t-correlation of psi, compared to free space electron wavefunc
    if ss.plot_tcorrPsi
        free_psip        = kvec.*free_psip;
        r.tcorrPsi(iter)   = abs(sum(sum(conj(free_psip).*r.psi_p)));         
    end

    % probability current
    if ss.plot_probcur
        [r.GradXpsi, r.GradYpsi] = gradient(r.psi, ss.delx, ss.dely);           %Compute spatial  gradient of psi and make grid 
        r.vXpsi = (-1i * hbar * r.GradXpsi) / ss.meff;                     %Compute velocity operator of PsiX
        r.vYpsi = (-1i * hbar * r.GradYpsi) / ss.meff;                     %Compute velocity operator of Psi
        r.Jx = 1/2 * (conj(r.psi) .* r.vXpsi + conj(r.vXpsi) .* r.psi);       %Compute probabilty current X component
        r.Jy = 1/2 * (conj(r.psi) .* r.vYpsi + conj(r.vYpsi) .* r.psi);       %Compute probabilty current Y component
    end


    if ss.real_time_fig
        visualize(r,ss,mainFig,iter)
    end


end

%% close video
if ss.save_video
    close(r.outputVideo);
end

% display(strcat('-> Simulation and Plotting take',' ',num2str(toc),' sec'))


% Normalize the cumulative sum matrix
r.Psi_k_dens_av = r.cumulativeSumMatrix / ss.N; % Normalization by the number of time steps


figure; 
imagesc(fftshift(r.Psi_k_dens_av)); % Plots the normalized matrix
colorbar; % Adds a color bar to the side of the figure to show the scaling of values
colormap('jet'); % Optional: Changes the color map to 'jet' for visual appeal
title('Normalized Cumulative Sum of abs(psip)^2'); 
xlabel('kx');
ylabel('ky');
axis equal

end