% script on solving for the frozen eigenstates with formula 1

%%
% 
% $$\sigma(\omega)=-\frac{\mathrm{i} e^2 \hbar}{{V}m^2} \sum_{m,n} \frac{f_m-f_n}{\varepsilon_{m n}} \frac{\left\langle m \left|\hat{p}_x\right| n\right\rangle\left\langle n\left|\hat{p}_x\right| m\right\rangle}{\hbar(\omega+\mathrm{i} \eta)+\varepsilon_{mn}}$$
% 

function r = f1_froz_ddp(fileName,T,seed)

addallpath

s = read_input(fileName);

s.T = T;
s.seed = seed;

ss = setup(s);

[tmp.psi,tmp.psip,r.E] = show_bound_state(ss);

tmp.n = length(r.E);

r.Px = zeros(tmp.n,tmp.n);

tmp.kx_psip = zeros(size(tmp.psip));

for j=1:tmp.n
    tmp.kx_psip(:,:,j) = ss.kx.*tmp.psip(:,:,j);
end

for i = 1 : tmp.n
    if mod(i,20) == 0
        tmp.rate = round(100*(2*tmp.n-i)*i/tmp.n^2);
        disp(['Seed=',num2str(seed),', T=',num2str(T),'K, ', num2str(tmp.rate, '%d'), '% completed'])
    end
    for j = i+1 : tmp.n
        r.Px(i,j) = sum(sum(conj(tmp.psip(:,:,i)).*tmp.kx_psip(:,:,j)));
    end
end

for i=1:tmp.n
    for j=1:i-1
        r.Px(i,j) = conj(r.Px(j,i));
    end
end

r.psi_low = tmp.psi(:,:,1);
r.psi_high = tmp.psi(:,:,end);

clear s
clear ss
clear i
clear j
clear tmp

save_h5([fileName, '_', num2str(T), 'K_', num2str(seed), 'sd'])

end
