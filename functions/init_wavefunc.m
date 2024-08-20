function psi = init_wavefunc(ss)
% initialize wavefunction. ss: the struct of all the input variables with SI unit
    switch ss.WP_type
        case 'Gaussian' % Gaussian wave packet
            
            % define wave function
            psi = exp(-(ss.y-ss.y0).^2/(2*ss.sigma_y)^2-(ss.x-ss.x0).^2/(2*ss.sigma_x)^2).*...
            exp(1i*ss.kF*(ss.x*cosd(ss.theta)+ss.y*sind(ss.theta)));

            if ss.two_body  % 2 body symmetried wave packet
                psi1 = exp(-(ss.y-ss.y0).^2/(2*ss.sigma_y)^2-(ss.x-ss.x0).^2/(2*ss.sigma_x)^2).*...
                      exp(1i*ss.kF*(ss.x*cosd(ss.theta)+ss.y*sind(ss.theta)));
                psi2 = exp(-(ss.y+ss.y0).^2/(2*ss.sigma_y)^2-(ss.x+ss.x0).^2/(2*ss.sigma_x)^2).*...
                      exp(-1i*ss.kF*(ss.x*cosd(ss.theta)+ss.y*sind(ss.theta)));
                psi =  psi1+psi2;
            end

            % Normalization of wavefunction
            norm = sum(sum(conj(psi).*psi)); % no need to add facter delx or dely, which will be added in fft
            psi  = psi/sqrt(norm);
            psi  = ss.density*psi;
            
        case 'PlaneWave'
            % define wave function
            psi = exp(1i*ss.kF*(ss.x*cosd(ss.theta)+ss.y*sind(ss.theta)));
            % Normalization of wavefunction
            norm = sum(sum(conj(psi).*psi)); % no need to add facter delx or dely, which will be added in fft
            psi  = psi/sqrt(norm);
            psi  = ss.density*psi;

        otherwise
            error('Unknown wave function type.');
    end
end
