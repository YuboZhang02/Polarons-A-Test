addallpath

%%
material = 'SrRuO_lat';

for seed = 1:20

    T = 50
    r=f1_plt_ddp(material,seed,T,0,0.04,0.00005,0.00005);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 100
    r=f1_plt_ddp(material,seed,T,0,0.1,0.0001,0.0001);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 150
    r=f1_plt_ddp(material,seed,T,0,0.15,0.0002,0.0002);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 200
    r=f1_plt_ddp(material,seed,T,0,0.2,0.0002,0.0002);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 300
    r=f1_plt_ddp(material,seed,T,0,0.3,0.0003,0.0003);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 400
    r=f1_plt_ddp(material,seed,T,0,0.4,0.0005,0.0005);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    T = 500
    r=f1_plt_ddp(material,seed,T,0,0.4,0.0005,0.0005);
    eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])
    
    clear r
    save(['SrRuO_lat_sd',num2str(seed)])

end

%%
material = 'SrRuO';

% seed = str2double(getenv('SLURM_ARRAY_TASK_ID'));
seed = 1;

%%
T = 25
r=f1_plt_ddp(material,seed,T,0,0.01,0.00002,0.00002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

%%
T = 50
r=f1_plt_ddp(material,seed,T,0,0.04,0.00005,0.00005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

%%
T = 100
r=f1_plt_ddp(material,seed,T,0,0.1,0.0001,0.0001);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 150
r=f1_plt_ddp(material,seed,T,0,0.15,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 200
r=f1_plt_ddp(material,seed,T,0,0.2,0.0002,0.0002);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 300
r=f1_plt_ddp(material,seed,T,0,0.3,0.0003,0.0003);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 400
r=f1_plt_ddp(material,seed,T,0,0.4,0.0005,0.0005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

T = 500
r=f1_plt_ddp(material,seed,T,0,0.4,0.0005,0.0005);
eval([material, '_', num2str(T),'K_',num2str(seed),'sd','=r;'])

clear r
save(['SrRuO_sd',num2str(seed)])