function draw_RePsiP(ss, r)
            q_range = 2*ss.qD;    % set the lim to show the alpha_q
            % redefine coordinate for plotting
            [kx1,ky1] = meshgrid([-ss.nx*ss.delkx:ss.delkx:(-ss.delkx), 0:ss.delkx:ss.nx*ss.delkx], ...
                                 [-ss.ny*ss.delky:ss.delky:(-ss.delky), 0:ss.delky:ss.ny*ss.delky]);
            
            % adjust the alpha1
            psi_p1 = r.psi_p([ss.nx+1:end, 1:ss.nx], [ss.ny+1:end, 1:ss.ny]);

            % extract values from kx1, ky1 and alpha1 to create kx2, ky2 and alpha2
            idx_kx = find((kx1(1,:) >= -q_range) & (kx1(1,:) <= q_range));
            idx_ky = find((ky1(:,1) >= -q_range) & (ky1(:,1) <= q_range));
            
            kx2 = kx1(1, idx_kx);
            ky2 = ky1(idx_ky, 1);
            psi_p2 = psi_p1(idx_kx, idx_ky);
            
            imagesc(kx2, ky2, abs(psi_p2));
            colorbar;
            xlabel('kx(m^{-1})');
            ylabel('ky(m^{-1})');
            title('Re(\psi(p)),Wavefunc in momentum space');
            tmp_cmap = choose_colormap(163);
            colormap(gca, tmp_cmap); % Apply colormap to the current axes
            axis equal
            xlim([-q_range,q_range])
            ylim([-q_range,q_range])
end