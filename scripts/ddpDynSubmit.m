% ddp cluster submission script dynamic potential

seed = str2double(getenv('SLURM_ARRAY_TASK_ID'));
% seed = 1;

material = getenv('MATERIAL');
% material = 'SrRuO';

T_vec_str = getenv('T_VEC');
T_vec = str2double(strsplit(T_vec_str, ','));
% T_vec = [1];


parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))
% parpool('local', 1)

addallpath

% T_vec = [5];

tic

parfor i = 1:length(T_vec)
    try
        T = T_vec(i);
        f2_dyn_ddp(material,T,seed,1,0);
        % save_h5([material, '_', num2str(T), 'K_', num2str(seed), 'sd']);
    catch ME
        disp(['Error in iteration ', num2str(i), ': ', ME.message]);
    end
end

toc

delete(gcp);
