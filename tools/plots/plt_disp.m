% plot dispersion relation 
% redefine coordinate for plotting
function plt_disp(ss,omega)
figure
[kx1,ky1] = meshgrid([-ss.nx*ss.delkx:ss.delkx:(-ss.delkx), 0:ss.delkx:ss.nx*ss.delkx], ...
                    [-ss.ny*ss.delky:ss.delky:(-ss.delky), 0:ss.delky:ss.ny*ss.delky]);
 
% adjust the omega
omega1 = omega([ss.nx+1:end, 1:ss.nx], [ss.ny+1:end, 1:ss.ny]);
contourf(kx1(1,:), ky1(:,1), omega1'.*(hbar/e));
colorbar;
xlabel('kx(m^{-1})');
ylabel('ky(m^{-1})');
title('Dispersion relation of phonon (eV)');
end