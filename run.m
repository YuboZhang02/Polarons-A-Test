% To start, type: run('template') 

% ======================================================================
%       Wave-on-Wave simulation with back-action in 2D lattice
%                    version 2.0, Sep 15, 2023
% ======================================================================
%
% Developed by Xiaoyu Ouyang and Shaobing Yuan, Heller Group at Harvard
% 
% Based on codes by Alhun Aydin, Joonas Keski-Rahkonen and Anton Graf
% 
% Thanks to Ke Lin, Vivek Kumar and MyeongSeo Kim for kindly contribution
% 
% Latest code available at github.com/Heller-Group/Wave-on-Wave
%
% Contact Xiaoyu(ouyangxiaoyu@stu.pku.edu.cn) for any questions

function [s,ss,result] = run(fileName)
tic
% add all the directory path to the current one
addallpath

% read all the input parameters as a struct s
s = read_input(fileName);

% setup all the parameters as a struct ss with SI unit
ss = setup(s);

% % show bound state
% if ss.bound_state
%     if ss.E~=0 % if there's the electric field
%         disp('Cannot solve for bound state since peridocial condition not compatable with electric field')
%     else
%         [psi_bs, psip_bs, E_bs] = show_bound_state(ss);
%     end
% end

% let wave packet propagate
result = propagate(ss);

% load the variables in the struct into the func workspace
fields = fieldnames(result);
for i = 1:length(fields)
    eval([fields{i}, ' = result.(fields{i});']);
end

clear i

% save all the data (except struct) in the workspace to hdf5 file
save_h5(fileName)

% assign result to the workspace directly
assignin("caller",fileName,result)
toc
end