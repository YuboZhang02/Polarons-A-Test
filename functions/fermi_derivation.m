function df_de = fermi_derivation(energy,temperature)
% the Fermi thermalized distribution derivation
kB = 1.3806e-23;
beta = 1./(kB*temperature);
df_de = beta./(4*cosh(beta.*energy/2));
end

