addallpath

material = 'Bi2212';

seed = str2double(getenv('SLURM_ARRAY_TASK_ID'));

T = 25
r=f1_plt_ddp(material,seed,T,0,0.01,0.00001,0.00001);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 50
r=f1_plt_ddp(material,seed,T,0,0.03,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 100
r=f1_plt_ddp(material,seed,T,0,0.06,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 150
r=f1_plt_ddp(material,seed,T,0,0.1,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 200
r=f1_plt_ddp(material,seed,T,0,0.12,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 300
r=f1_plt_ddp(material,seed,T,0,0.2,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 400
r=f1_plt_ddp(material,seed,T,0,0.24,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 500
r=f1_plt_ddp(material,seed,T,0,0.3,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

clear r
save(['Bi2212_sd',num2str(seed)])