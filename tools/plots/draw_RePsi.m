function draw_RePsi(r,ss)

% 1st fig, Re(psi)

imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, real(r.psi))
title('Colored Re(\psi) & contoured potential')
xlabel('x(m)')
ylabel('y(m)')
colormap(choose_colormap(104))   % set colormap for this subplot
colorbar
top=max(max(abs(real(r.psi))));
caxis([-top top])  % set color map limits for this subplot
axis equal
xlim([-ss.Lx/2 ss.Lx/2]) % Set x-axis limits
ylim([-ss.Ly/2 ss.Ly/2]) % Set y-axis limits

hold on
contour(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, r.U, 'LineWidth',1,'EdgeColor','black'); % Create image object for deformation potential
hold off

end