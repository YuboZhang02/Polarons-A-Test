function draw_xcorrU(r, ss)
            % Calculate the spatial correlation function
            U = r.U - mean(r.U(:));            % Subtract the mean of U
            F = fft2(U);                   % Calculate the FFT of U
            P = abs(F).^2;                 % Calculate the power spectrum
            corrU = ifft2(P);              % Calculate the inverse FFT of the power spectrum
            corrU = real(corrU);           % Take the real part (to remove any small imaginary parts due to numerical errors)
            corrU = fftshift(corrU);       % Shift the zero-frequency 
                                           % component to the center of the spectrum
            corrU = corrU / max(corrU(:)); % Normalize the correlation function
            
            % Visualize the spatial correlation function
            imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, corrU);
            colorbar;
            tmp_cmap = choose_colormap(163);
            colormap(gca, tmp_cmap); % Apply colormap to the current axes
            xlabel('x(m)');
            ylabel('y(m)');
            title('Spatial correlation function of U');
            axis equal
end