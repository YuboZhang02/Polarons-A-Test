function draw_msd(r, ss)
            plot(r.Msd)
            title('Mean square distance')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            ylabel('square distance (m^2)')
end