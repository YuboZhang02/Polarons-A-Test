% ddp cluster submission script frozen potential

seed = str2double(getenv('SLURM_ARRAY_TASK_ID'));
% seed = 1;

material = getenv('MATERIAL');
% material = 'SrRuO';

T_vec_str = getenv('T_VEC');
T_vec = str2double(strsplit(T_vec_str, ','));

parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))
% parpool('local', 1)

addallpath

% T_vec = [50];

tic

parfor i = 1:length(T_vec)
    try
        T = T_vec(i);
        f1_froz_ddp(material,T,seed);
        % save_h5([material, '_', num2str(T), 'K_', num2str(seed), 'sd']);
    catch ME
        disp(['Error in iteration ', num2str(i), ': ', ME.message]);
    end
end

toc

delete(gcp);
