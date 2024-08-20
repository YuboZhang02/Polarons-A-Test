function draw_probcur(ss, r)

contourf(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, r.U, 20); % Contour plot with 20 levels
hold on; % Keep the plot for superposing the quiver plot
quiver(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, r.Jx, r.Jy, 15, 'AutoScale', 'off', 'Color', 'g'); % Quiver plot in red for visibility
title('Probability Current with Potential')
xlabel('x(m)');
ylabel('y(m)');
axis equal;
axis square;
colormap(gca, choose_colormap(38)); % Choose an appropriate colormap
colorbar

% Apply dynamic zoom
zoomLevel = 5; % Define zoom level based on your simulation requirements
xlim([-ss.Lx/2 ss.Lx/2] / zoomLevel); % Set x-axis limits based on zoom level
ylim([-ss.Ly/2 ss.Ly/2] / zoomLevel); % Set y-axis limits based on zoom level
hold off; % Release the plot


end