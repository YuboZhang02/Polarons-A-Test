function draw_blurredpotent(ss, r)
            imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, r.Ublur); % Create image object for deformation potential
            title(['Blurred Potential, blur=',num2str(ss.blur)])
            xlabel('x(m)')
            ylabel('y(m)')
            tmp_cmap = choose_colormap(163);
            colormap(gca, tmp_cmap); % Apply colormap to the current axes
            colorbar
            Umax = max(max(ss.U_0));
            Umin = min(min(ss.U_0));
            if ss.potential_lim_fix
                caxis([Umin,Umax])
            end
            axis equal
            xlim([-ss.Lx/2 ss.Lx/2]) % Set x-axis limits
            ylim([-ss.Ly/2 ss.Ly/2]) % Set y-axis limits
end