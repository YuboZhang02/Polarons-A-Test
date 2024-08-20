% run this to get the bound state (E_bs and psi_bs) of frozen deformation potential V
function [psi_bs, psip_bs, E_bs] = show_bound_state(ss)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Mass = ss.mass;           %% effective mass, constant over all the structure...

V0=ss.U_0;

disp('=======================================')

NGx = ss.bsNx/2-1;   %Nx/2-1  ;    % number of harmonics % must be at least 2 times -1 smaller than Nz (smaller => faster)
NGy = ss.bsNy/2-1;   %Ny/2-1  ;    % number of harmonics % must be at least 2 times -1 smaller than Nz (smaller => faster)

tic

if ss.Nx == NGx && ss.Ny == NGy
    [E_bs,psi_bs,psip_bs] = PWE_new(ss);
    display(strcat('-> new PWE method =',num2str(toc),'sec'))
else
    [E_bs,psi_bs,psip_bs] = Schroed2D_PWE_f(ss.x(1,:),ss.y(:,1),V0,Mass,ss.bsNx,ss.bsNy,NGx,NGy,ss.EF,ss.T,ss.EF_range);
    display(strcat('-> old PWE method =',num2str(toc),'sec'))
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('=======================================')
disp('Results:')
disp('=======================================')
disp(strcat('E-EF (eV)='))
disp(strcat(num2str(E_bs/e)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot #n_plt eigenstates

c=0;
ii=0;
n = size(psi_bs,3);
if ss.plt_all_solved_states
    for i=1:n
        if mod(i-1,15) == 0
            
            figure('Name','PWE method','position',[100 100 1600 900])
            c=c+1;
            ii=0;
        end
        ii=ii+1;
        
        subplot(3,5,ii,'fontsize',12)
        hold on
        
        pcolor(ss.x*1e9,ss.y*1e9,real(psi_bs(:,:,i)) )
        % contour(x*1e9,y*1e9,V0,1,'linewidth',3,'linecolor','w')
        
        xlabel('x (nm)')
        ylabel('y (nm)')

        title(strcat('E',num2str(i),'=',num2str(1000*(ss.EF+E_bs(i,1))/e,'%.4f'),'meV'))
        %axis equal
        shading flat
        colormap(choose_colormap(104))
        if mod(i,15) == 0
            saveas(gcf, strcat(ss.fileName,'_bound_state', num2str(i), '.png'));
        end
    end
elseif ~ss.use_cluster % only plot the lowest/highest energy state
    i=1;
    figure
    pcolor(ss.x*1e9,ss.y*1e9,real(psi_bs(:,:,i)) )
    xlabel('x (nm)')
    ylabel('y (nm)')
    shading flat
    title(strcat('lowest E',num2str(i),'=',num2str(1000*(ss.EF+E_bs(i,1))/e,'%.4f'),'meV'))
    colormap(choose_colormap(104))

    i=n;
    figure
    pcolor(ss.x*1e9,ss.y*1e9,real(psi_bs(:,:,i)) )
    xlabel('x (nm)')
    ylabel('y (nm)')
    shading flat
    title(strcat('highest E',num2str(i),'=',num2str(1000*(ss.EF+E_bs(i,1))/e,'%.4f'),'meV'))
    colormap(choose_colormap(104))
end

if ~ss.use_cluster
    figure('Name','Frozen Deformation Potential (include others)')
    imagesc(-ss.Lx/2:ss.delx:ss.Lx/2, -ss.Ly/2:ss.dely:ss.Ly/2, ss.U_0); % Create image object for deformation potential
    xlabel('x(m)')
    ylabel('y(m)')
    title('Frozen deformation potential')
    tmp_cmap = choose_colormap(163);
    colormap(gca, tmp_cmap); % Apply colormap to the current axes
    colorbar
    axis equal
    xlim([-ss.Lx/2 ss.Lx/2])  % Set x-axis limits
    ylim([-ss.Ly/2 ss.Ly/2]) % Set y-axis limits
end

end