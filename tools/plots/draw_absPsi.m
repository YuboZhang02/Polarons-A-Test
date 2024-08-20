function draw_absPsi(ss, r)
            imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, abs(r.psi)); % Create image object for |psi|^2
            title('|\psi|')
            xlabel('x(m)')
            ylabel('y(m)')
            tmp_cmap = choose_colormap(52);
            colormap(gca, tmp_cmap); % Apply colormap to the current axes
            colorbar
            axis equal
            xlim([-ss.Lx/2 ss.Lx/2]) % Set x-axis limits
            ylim([-ss.Ly/2 ss.Ly/2]) % Set y-axis limits
end