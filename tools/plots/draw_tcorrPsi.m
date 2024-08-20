function draw_tcorrPsi(r, ss)
            plot(r.tcorrPsi)
            title('Wavefunc Correlation btw deformation potential and free space')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            ylabel('\langle \psi_{free} | \psi \rangle')
end