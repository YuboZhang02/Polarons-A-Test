addallpath

material = 'LSCO';

seed = str2double(getenv('SLURM_ARRAY_TASK_ID'));

T = 25
r=f1_plt_ddp(material,seed,T,0,0.001,0.00002,0.00002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 50
r=f1_plt_ddp(material,seed,T,0,0.02,0.00005,0.00005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 100
r=f1_plt_ddp(material,seed,T,0,0.1,0.0001,0.0001);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 150
r=f1_plt_ddp(material,seed,T,0,0.15,0.0001,0.0001);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 200
r=f1_plt_ddp(material,seed,T,0,0.15,0.0001,0.0001);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 300
r=f1_plt_ddp(material,seed,T,0,0.2,0.0005,0.0005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 400
r=f1_plt_ddp(material,seed,T,0,0.3,0.0005,0.0005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 500
r=f1_plt_ddp(material,seed,T,0,0.5,0.0005,0.0005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

clear r
save(['LSCO_sd',num2str(seed)])