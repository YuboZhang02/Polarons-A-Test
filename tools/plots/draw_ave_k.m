function draw_ave_k(r, ss)
            hold on
            plot(r.Ave_kxky(1,:))
            plot(r.Ave_kxky(2,:))
            legend('kx','ky')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            ylabel('wavevec(m^{-1})')
            hold off
            title('Average momentum')
end