function [psi, alpha, U, V] = split_operator(psi, alpha, Nx, Ny, two_body, g_q, H_xy, tau, hbar, B, half_kvec, xkyvec, dynamic, omega, back_action)

    FT_V = Nx*Ny*2*g_q.*alpha;          % Fourier Transformation of deformation potential
        
    if two_body
        V = 2*real(ifft2(real(FT_V)));   % deformation potential in the real space (two body)
    else
        V = real(ifft2(FT_V));           % deformation potential in the real space (one body)
    end
    
    %% equation of motion
    init_psi  = psi;
    U         = V+H_xy;                      % total potential
    half_xvec = exp(-1j*U/2*tau/hbar);       % Potential split propagator
    
    if B==0
        psi_k     = fft2(half_xvec.*init_psi);
        half_psik = half_kvec.*psi_k;           % motion of the electron (half step)
        psi       = half_xvec.*ifft2(half_kvec.*half_psik);
        half_psi  = ifft2(half_psik);
    else
        psi_k     = fft(xkyvec.*fft(half_xvec.*psi),[],2);
        half_psik = half_kvec.*psi_k;
        psi       = half_xvec.*ifft(xkyvec.*ifft(half_kvec.*half_psik,[],2));
        half_psi  = ifft2(half_psik);
    end
    
    % The Fourier transformed electron probability density
    b1=0;b2=0;b3=1;
    if two_body
        density_fft = 2.*real(fft2(b1*init_psi.*conj(init_psi) + b2*half_psi.*conj(half_psi) + b3*psi.*conj(psi))); 
    else
        density_fft = fft2(b1*init_psi.*conj(init_psi) + b2*half_psi.*conj(half_psi) + b3*psi.*conj(psi)); 
    end
    
    % motion of lattice vibration
    alpha = exp(-1i*double(dynamic)*tau*omega).*alpha;
    alpha = alpha-double(dynamic)*1i*tau*...
            (double(back_action)*g_q.*density_fft/hbar); 

end