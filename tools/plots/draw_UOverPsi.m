function draw_UOverPsi(ss,r)

imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, r.U); % Create image object for |psi|^2
title('Colored potential & contoured |\psi|')
xlabel('x(m)')
ylabel('y(m)')
tmp_cmap = choose_colormap(163);
colormap(gca, tmp_cmap); % Apply colormap to the current axes
colorbar
axis equal
xlim([-ss.Lx/2 ss.Lx/2]) % Set x-axis limits
ylim([-ss.Ly/2 ss.Ly/2]) % Set y-axis limits


if ss.potential_lim_fix
    Umax = max(max(ss.U_0));
    Umin = min(min(ss.U_0));
    caxis([Umin,Umax]);
else
    caxis([min(min(r.U)),max(max(r.U))]);
end

hold on
contour(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, abs(r.psi), 'LineWidth',1,'EdgeColor','black'); % Create image object for deformation potential

hold off

end