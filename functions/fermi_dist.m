function occupy_num = fermi_dist(energy,temperature)
% the Fermi thermalized distribution
kB = 1.3806e-23;
occupy_num = 1./(1+exp(energy/(kB*temperature)));
end