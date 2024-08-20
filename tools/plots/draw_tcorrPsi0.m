function draw_tcorrPsi0(r, ss)
            plot(r.tcorrPsi0)
            title('Wavefunc Correlation with initial state')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            ylabel('\langle \psi (0)  | \psi (t) \rangle')
end