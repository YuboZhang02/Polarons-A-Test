load ddpresult.mat

%% plot single seed result
material = 'SrRuO_lat';
seed = 1;
figure 
hold on 

T_vec = [50];
legends = cell(size(T_vec));

for idx = 1:length(T_vec)
    T = T_vec(idx);
    eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])
    plot(r.hbar_omega,r.conductivity, 'LineWidth', 2);
    
    legends{idx} = ['T=', num2str(T), 'K'];
end

legend(legends)
grid on
box on
ylim([0,10000])
xlim([0,0.3])
title(['Drude peak of ', material, '(sample ',num2str(seed),')'])
xlabel('\omega (eV)')
ylabel('Conductivity \sigma (S)')
set(gca,'fontsize',18)

hold off

%% plot all seed results
material = 'SrRuO_lat';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));

for seed = seed_vec
    seed
    for idx = 1:length(T_vec)
        T = T_vec(idx);
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])
        plot(r.hbar_omega,r.conductivity, 'LineWidth', 2);
        if seed == 1
            legends{idx} = ['T=', num2str(T), 'K'];
            
        end
        

    end
end

legend(legends)
grid on
box on
ylim([0,10000])
xlim([0,0.3])
title(['Drude peak of ', material, '(sample ',num2str(seed),')'])
xlabel('\omega (eV)')
ylabel('Conductivity \sigma (S)')
set(gca,'fontsize',18)

hold off

%% plot all seed averaged results
material = 'SrRuO';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));

for idx = 1:length(T_vec)
    for seed = seed_vec
        T = T_vec(idx);
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])
        
        if seed == 1
            ave_conduct = r.conductivity;
            matrix_conduct = r.conductivity;
        else
            ave_conduct = ave_conduct + r.conductivity;
            matrix_conduct = [matrix_conduct;r.conductivity];
        end
        std_conduct = std(matrix_conduct, 0, 1);
    
    end
    ave_conduct = ave_conduct./length(seed_vec);
    
    hLine = plot(r.hbar_omega,ave_conduct, 'LineWidth', 2);

    % Saving to txt
    data_to_save = [r.hbar_omega(:), ave_conduct(:)];
    filename = [material,'_peakcurve_',num2str(T),'K.txt'];
    header = 'omega conductivity';  % column headers
    dlmwrite(filename, header, 'delimiter', '', 'newline', 'pc');
    dlmwrite(filename, data_to_save, '-append', 'delimiter', '\t');  % append data after header 

    
    lineColor = hLine.Color;
    
    legends{idx} = ['T=', num2str(T), 'K'];

    % hFill = fill([r.hbar_omega, fliplr(r.hbar_omega)], [ave_conduct - std_conduct, fliplr(ave_conduct + std_conduct)], lineColor, 'FaceAlpha', 0.4,'EdgeColor','none');
    % set(hFill, 'HandleVisibility', 'off');
    
end


legend(legends)
grid on
box on
ylim([0,25000])
xlim([0,0.3])
title(['Drude peak of ', material, ' (sample 1-20)'])
xlabel('\omega (eV)')
ylabel('Conductivity \sigma (S)')
set(gca,'fontsize',18)

hold off

%% plot the location of each peak
material = 'SrRuO';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));

for seed = seed_vec
    
    for idx = 1:length(T_vec)
        T = T_vec(idx);
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])

        [~, max_omega_idx] = max(r.conductivity);
        plot(T,r.hbar_omega(max_omega_idx),'Marker','o');
        if seed == 1
            legends{idx} = ['T=', num2str(T), 'K'];
            
        end
    end
end

legend(legends)
grid on
box on
% ylim([0,10000])
% xlim([0,0.3])
title(['Peak location of ', material, ' (sample 1-20)'])
xlabel('T (K)')
ylabel('\omega (eV)')
set(gca,'fontsize',18)

hold off

%% plot the averaged location of each peak with errorbar
material = 'LSCO';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));

filename = [material,'_peakloc.txt'];
header = 'temperature omega_peak std';  % column headers
dlmwrite(filename, header, 'delimiter', '', 'newline', 'pc');

for idx = 1:length(T_vec)
    T = T_vec(idx);
    max_omega = [];
    for seed = seed_vec
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])

        [~, max_omega_idx] = max(r.conductivity);

        max_omega = [max_omega; r.hbar_omega(max_omega_idx)];

        % plot(T,r.hbar_omega(max_omega_idx),'Marker','o');
        % if seed == 1
        %     legends{idx} = ['T=', num2str(T), 'K'];
        % 
        % end
    end
    ave_max_omega = mean(max_omega);
    std_max_omega = std(max_omega);
    errorbar(T,ave_max_omega,std_max_omega,'o','MarkerSize',10,'LineWidth',2)
    
    % Saving to txt
    data_to_save = [T, ave_max_omega, std_max_omega];
    
    dlmwrite(filename, data_to_save, '-append', 'delimiter', '\t');  % append data after header 

    legends{idx} = ['T=', num2str(T), 'K'];
end

legend(legends)
plot(T_vec,30*kB*sqrt(T_vec)/e)
grid on
box on
% ylim([0,10000])
% xlim([0,0.3])
title(['Peak location of ', material, ' (sample 1-20)'])
xlabel('T (K)')
ylabel('\omega (eV)')
set(gca,'fontsize',18)

hold off

%% plot the width of each peak
material = 'SrRuO';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));


for seed = seed_vec
    
    for idx = 1:length(T_vec)
        T = T_vec(idx);
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])

        [max_conductivity, max_omega_idx] = max(r.conductivity);

        omega_right = r.hbar_omega(max_omega_idx:end);
        conduct_right = r.conductivity(max_omega_idx:end);
        
        [~, omega_width_idx] = min(abs(conduct_right-0.9.*max_conductivity));
        omega_width = omega_right(omega_width_idx)-omega_right(1);

        plot(T,omega_width,'Marker','o');
        if seed == 1
            legends{idx} = ['T=', num2str(T), 'K'];
            
        end
    end
end

legend(legends)
grid on
box on
% ylim([0,10000])
% xlim([0,0.3])
title(['Peak Width of ', material, ' (sample 1-20)'])
xlabel('T (K)')
ylabel('\omega (eV)')
set(gca,'fontsize',18)

hold off

%% plot the averaged width of each peak with errorbar
material = 'Bi2212';

figure 
hold on 

T_vec = [50,100,150,200,300,400,500];
seed_vec = linspace(1,20,20);
legends = cell(size(T_vec));

filename = [material,'_peakwidth.txt'];
header = 'temperature omega_width std';  % column headers
dlmwrite(filename, header, 'delimiter', '', 'newline', 'pc');

for idx = 1:length(T_vec)
    width_vec = [];
    for seed = seed_vec
        T = T_vec(idx);
        eval(['r = ', material, '_', num2str(T), 'K_', num2str(seed), 'sd;'])

        [max_conductivity, max_omega_idx] = max(r.conductivity);

        omega_right = r.hbar_omega(max_omega_idx:end);
        conduct_right = r.conductivity(max_omega_idx:end);
        
        [~, omega_width_idx] = min(abs(conduct_right-0.9.*max_conductivity));
        omega_width = omega_right(omega_width_idx)-omega_right(1);
        width_vec = [width_vec;omega_width];

        % plot(T,omega_width,'Marker','o');
        % if seed == 1
        %     legends{idx} = ['T=', num2str(T), 'K'];
        % end
    end
    ave_width = mean(width_vec);
    std_width = std(width_vec);
    errorbar(T,ave_width,std_width,'o','MarkerSize',10,'LineWidth',2)
    data_to_save = [T, ave_width, std_width];
    
    dlmwrite(filename, data_to_save, '-append', 'delimiter', '\t');  % append data after header 
    legends{idx} = ['T=', num2str(T), 'K'];
end

legend(legends)
plot(T_vec,kB*T_vec/e)
grid on
box on
% ylim([0,10000])
% xlim([0,0.3])
title(['Peak Width of ', material, ' (sample 1-20)'])
xlabel('T (K)')
ylabel('\omega (eV)')
set(gca,'fontsize',18)

hold off