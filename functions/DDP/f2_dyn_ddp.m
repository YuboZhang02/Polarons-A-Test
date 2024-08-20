function r = f2_dyn_ddp(fileName,T,seed,timeLength,dynamic)
%F2_DYN_DDP 

addallpath
s = read_input(fileName);
s.T = T;
s.seed = seed;
ss = setup(s);

ss.save_all_time = false;
ss.back_action = false;
ss.dynamic =  dynamic;
ss.real_time_fig = false;
ss.N = 1;

[es.psi,es.psip,es.E] = show_bound_state(ss);
es.n = length(es.E);

% the initial state to evolve
tmp.psip = es.psip;

% vx operator
tmp.vx =  hbar*ss.kx./ss.mass;

% the time correlation function that to be integrated
r.tcorrf = zeros(timeLength,1);

for timeIter=1:timeLength
    if mod(timeIter,1)==0
        tmp.rate = 100*timeIter/timeLength;
        disp(['Seed=',num2str(seed),', T=',num2str(T),'K, ', num2str(tmp.rate, '%d'), '% completed'])
    end

    % matrix element for eigenstate i and j
    tmp.mat_ele = zeros(es.n,es.n);

    for i=1:es.n
        tmp.psi = ifft2(tmp.psip(:,:,i));
        update_r = propagate(ss);
        tmp.psi = update_r.psi;
        tmp.psip(:,:,i) = fft2(tmp.psi);
        
        % in the last eigenstate we update the alpha
        if i==es.n
            ss.alpha_0 = update_r.alpha;
        end

        for j=1:i-1
            tmp.bk1 = sum(sum(conj(tmp.psip(:,:,i)).*tmp.vx.*tmp.psip(:,:,j)));
            tmp.bk2 = sum(sum(conj(es.psip(:,:,j)).*tmp.vx.*es.psip(:,:,i)));
            df_dE   = (fermi_dist(es.E(i),T)-fermi_dist(es.E(j),T))/(es.E(i)-es.E(j));
            tmp.mat_ele(i,j) =  df_dE * real(tmp.bk1 * tmp.bk2);
        end
    end
    r.tcorrf(timeIter) = sum(sum(tmp.mat_ele));
end

clear s
clear ss
clear i
clear j
clear tmp
clear timeIter
clear es
clear update_r

save_h5([fileName, '_', num2str(T), 'K_', num2str(seed), 'sd_dyn'])

end


