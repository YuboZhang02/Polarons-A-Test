% plot the eigenstate around Fermi energy and deformation potential in the
% same figure

load SrRuO_es.mat

%%
material = 'SrRuO';

s = read_input(material);
s.EF_range = 0;
s.use_cluster = 1;

T_vec = [25,50,100,200];
psi_SrRuO_F = zeros(ss.Nx,ss.Ny,length(T_vec));
U_SrRuO = zeros(ss.Nx,ss.Ny,length(T_vec));

for i = 1:length(T_vec)
    s.T = T_vec(i);
    ss = setup(s);
    U_SrRuO(:,:,i) = ss.U_0;
    [psi_bs, ~, E_bs] = show_bound_state(ss);
    abs_E_bs = abs(E_bs);
    [~, idx] = min(abs_E_bs);
    psi_SrRuO_F(:,:,i) = psi_bs(:,:,idx);
end

%%
material = 'LSCO';

s = read_input(material);
s.EF_range = 0;
s.use_cluster = 1;

T_vec = [25,50,100,200];
psi_LSCO_F = zeros(ss.Nx,ss.Ny,length(T_vec));
U_LSCO = zeros(ss.Nx,ss.Ny,length(T_vec));

for i = 1:length(T_vec)
    s.T = T_vec(i);
    ss = setup(s);
    U_LSCO(:,:,i) = ss.U_0;
    [psi_bs, ~, E_bs] = show_bound_state(ss);
    abs_E_bs = abs(E_bs);
    [~, idx] = min(abs_E_bs);
    psi_LSCO_F(:,:,i) = psi_bs(:,:,idx);
end

%%
material = 'Bi2212';

s = read_input(material);
s.EF_range = 0;
s.use_cluster = 1;
T_vec = [25,50,100,200];
psi_Bi2212_F = zeros(ss.Nx,ss.Ny,length(T_vec));
U_Bi2212 = zeros(ss.Nx,ss.Ny,length(T_vec));

for i = 1:length(T_vec)
    s.T = T_vec(i);
    ss = setup(s);
    U_Bi2212(:,:,i) = ss.U_0;
    [psi_bs, ~, E_bs] = show_bound_state(ss);
    abs_E_bs = abs(E_bs);
    [~, idx] = min(abs_E_bs);
    psi_Bi2212_F(:,:,i) = psi_bs(:,:,idx);
end

%% contour potential
close all 

% figure
% tl = tiledlayout(3,6);

for i = 1:length(T_vec)
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, abs(psi_SrRuO_F(:,:,i)).^2);
    tmp_cmap = choose_colormap(52);
    colormap(gca,tmp_cmap);
    figure
    % nexttile(tl)
    contour(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, U_SrRuO(:,:,i), 3, 'LineWidth',2)
    tmp_cmap = choose_colormap(166);
    colormap(gca,tmp_cmap(64:192,:));
    title(['T=',num2str(T_vec(i)),'K'])
    axis off
end

%% psi^2 on colored potential
close all
% figure
% tl = tiledlayout(3,6);

for i = 1:length(T_vec)
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, abs(psi_SrRuO_F(:,:,i)).^2);
    tmp_cmap = choose_colormap(40);
    colormap(gca,(tmp_cmap));
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, U_SrRuO(:,:,i))
    tmp_cmap = choose_colormap(149);
    colormap(gca,tmp_cmap);
    title(['T=',num2str(T_vec(i)),'K'])
    axis off
end

%% blue and red real psi on grey potential
close all
for i = 1:length(T_vec)
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, real(psi_SrRuO_F(:,:,i)));
    tmp_cmap = choose_colormap(103);
    colormap(gca,(tmp_cmap));
    top=max(max(real(psi_SrRuO_F(:,:,i))));
    caxis([-top top])  % set color map limits for this subplot  
    axis off
    axis equal
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, U_SrRuO(:,:,i))
    tmp_cmap = choose_colormap(7);
    colormap(gca,tmp_cmap);
    title(['T=',num2str(T_vec(i)),'K'])
    axis off
    axis equal
end

%% psi^2 on sequential color potential
close all
% figure
% tl = tiledlayout(3,6);

for i = 1:length(T_vec)
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, abs(psi_SrRuO_F(:,:,i)).^2);
    tmp_cmap = choose_colormap(83);
    colormap(gca,(tmp_cmap));
    figure
    % nexttile(tl)
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, U_SrRuO(:,:,i))
    tmp_cmap = choose_colormap(40);
    colormap(gca,tmp_cmap);
    title(['T=',num2str(T_vec(i)),'K'])
    axis off
end