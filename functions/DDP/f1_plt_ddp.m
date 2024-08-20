function r = f1_plt_ddp(material,seed,T,hbar_omega_min,hbar_omega_max,hbar_omega_step,eta0)
% f1_plt_ddp(Px,E_bs,T,Vol,mass,hbar_omega_min,hbar_omega_max,hbar_omega_step)
% plot DDP based on Px and omega range

% addallpath

read_h5([material,'_',num2str(T),'K_',num2str(seed),'sd'])

E_bs = r.E;
Px = r.Px;
psi_high = r.psi_high;
psi_low = r.psi_low;
clear r

f_E = fermi_dist(E_bs,T); 
eta = eta0*e;
n = length(E_bs);

s = read_input(material);
ss = setup(s);
Vol = ss.Vol;
mass = ss.mass;

hbar_omega_values = hbar_omega_min:hbar_omega_step:hbar_omega_max;

conductivity_values = zeros(size(hbar_omega_values));

for idx = 1:length(hbar_omega_values)
    hbar_omega = hbar_omega_values(idx);
    conductivity = 0;
    for j = 1:n
        for i = 1:n
            if i ~= j
                num = hbar^2 * (f_E(i) - f_E(j)) * abs(Px(i,j))^2;
                den = (e * hbar_omega + 1j*eta + (E_bs(i) - E_bs(j))) * (E_bs(i) - E_bs(j));
                conductivity = conductivity + num / den;
            end
        end
    end
    conductivity_values(idx) = - real(1j * hbar * e^2/(Vol*mass^2) * conductivity);
end

hbar_omega_values = hbar_omega_min:hbar_omega_step:hbar_omega_max;

r.conductivity = conductivity_values;
r.hbar_omega = hbar_omega_values;

if ~ss.use_cluster
    figure;
    plot(hbar_omega_values, conductivity_values, 'LineWidth', 2);
    xlabel('hbar \omega (eV)');
    ylabel('Conductivity (\sigma)');
    title([material,' Conductivity at T=',num2str(T),'K, seed=', num2str(seed)]);
    grid on;
    
    figure
    r_low.psi = psi_low;
    draw_RePsi(r_low,ss)
    title(['T=',num2str(T),'K, seed=',num2str(seed),', Lowest eigenstate with energy ', num2str(E_bs(1)/e), 'eV'])
    
    figure
    r_high.psi = psi_high;
    draw_RePsi(r_high,ss)
    title(['T=',num2str(T),'K, seed=',num2str(seed),', Highest eigenstate with energy ', num2str(E_bs(end)/e), 'eV'])
end

end

