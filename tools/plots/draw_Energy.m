function draw_Energy(r, ss)
            plot(r.Energy/e)
            hold on
            plot(r.elec_Ek/e)
            plot(r.elec_Ep/e)
            plot(r.vibr_E/e)
            title('Energy of system (eV)')
            xlabel(['timestep(',num2str(ss.tau*1e15),'fs)'])
            legend('Total energy','electron kinetic','electron potential','phonon energy')
            hold off
end