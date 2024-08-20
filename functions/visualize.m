function visualize(r,ss,mainFig,iter)
if ss.real_time_fig
    if mod(iter,ss.plot_interval)==1
        figure(mainFig.fig)
        
        if ss.save_video
            % Set the position and size of the figure
            set(gcf, 'Position', [mainFig.Left mainFig.Bottom mainFig.Length mainFig.Length/2]);
        else
            set(gcf, 'Position', [mainFig.Left mainFig.Bottom mainFig.Length mainFig.Width]);
        end

        % Set the name of the figure window
        windowTitle = ['T=',num2str(ss.T),'K, E=',num2str(ss.E),'V/m, B=',num2str(ss.B),'T, dynamic: ',num2str(ss.dynamic), ', back action: ',num2str(ss.back_action)];
        set(gcf, 'Name', windowTitle, 'NumberTitle', 'off');
        
        tl=tiledlayout(2,4);
        % title(tl, ['T=',num2str(ss.T),'K, E=',num2str(ss.E),'V/m, B=',num2str(ss.B),'T, dynamic: ',num2str(ss.dynamic), ', back action: ',num2str(ss.back_action)])

        if ss.plot_RePsi
            % 1st fig, Re(psi)
            nexttile(tl)
            draw_RePsi(r,ss);
        end

        if ss.plot_probcur
            % Plot the probability current
            nexttile(tl)
            draw_probcur(ss, r);
        end
        
        if ss.plot_potent
            % 2nd fig, whole deformation potential V
            nexttile(tl)
            draw_potent(ss, r);
        end

        if ss.plot_blurredpotent
            if ss.blur==0
                % 2nd fig, whole deformation potential V
                nexttile(tl)
                draw_potent(ss, r);
            elseif ss.blur>0 && ss.blur<1
                nexttile(tl)
                draw_blurredpotent(ss, r);
            end
        end
        
        if ss.plot_absPsi
            % 3rd fig, |psi|^2
            nexttile(tl)
            draw_absPsi(ss, r);
        end

        if ss.plot_PsiOverU
            nexttile(tl)
            draw_PsiOverU(ss, r);
        end

        if ss.plot_UOverPsi
            nexttile(tl)
            draw_UOverPsi(ss, r);
        end

        % 4th fig, average x and y
        if ss.plot_ave_xy
            nexttile(tl)
            draw_ave_xy(r, ss);
        end

        if ss.plot_ave_k
            % 5th fig, average kx and ky
            nexttile(tl)
            draw_ave_k(r, ss);
        end

        if ss.plot_msd
            % 6th fig, mean square distance
            nexttile(tl)
            draw_msd(r, ss);
        end

        if ss.plot_xcorrU
            nexttile(tl)
            % 7th fig, correlation of potential
            draw_xcorrU(r, ss);
        end
    
        if ss.plot_alpha
            % the distribution of alpha of deformation potential in momentum space
            nexttile(tl)
            draw_alpha(ss, r);
        end
        
        if ss.plot_tcorrPsi
            nexttile(tl)
            draw_tcorrPsi(r, ss);
        end

        if ss.plot_tcorrPsi0
            nexttile(tl)
            draw_tcorrPsi0(r, ss);
        end

        if ss.plot_tcorrU
            nexttile(tl)
            draw_tcorrU(r, ss);
        end

        if ss.plot_Energy
            % plot the total energy, electron kinetic and potential energy and phonon energy
            nexttile(tl)
            draw_Energy(r, ss);
        end

        if ss.plot_RePsiP
            % wavefunction in momentum space
            nexttile(tl)
            draw_RePsiP(ss, r);
        end

        if ss.save_video
            % Get the current frame and write it to the video
            currFrame = getframe(gcf);
            open(r.outputVideo);
            writeVideo(r.outputVideo, currFrame);
        end

        % If this is the last iteration, save the figure
        if iter == ss.N
            saveas(gcf, [ss.fileName '.png']);
        end
    end
end

end