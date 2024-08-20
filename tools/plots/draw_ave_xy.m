function draw_ave_xy(r, ss)
            hold on
            plot(r.Ave_xy(1,:))
            plot(r.Ave_xy(2,:))
            legend('x','y')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            ylabel('position(m)')
            hold off
            title('Average position')
end