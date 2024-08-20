function draw_tcorrU(r, ss)
            plot(r.tcorrU)
            title('Time correlation of potential')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
end