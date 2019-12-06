%% create spheres ... code for 4 spheres, easily chqnged o less or more
clear all; close all; clc


[node, face, cfg] = bst_mesh_sphere_surface;

%% volume mesh
cfg.node = node;
cfg.face = face;
cfg.maxvol = 0.1;
cfg.keepratio = 1;
cfg.plotMesh = 1;
[node,elem,face] = bst_mesh_sphere_volume(cfg);

%% generate rqndom electrode
cfg.node = node;
cfg.elem = elem;
cfg.nb_electrode = 32;
cfg.plotElectrode = 1;
elec_position = bst_generate_electrode(cfg);

%% compute ana
cfg.dip_position = [0 0 0]; % 3d
cfg.center  = cfg.c0 ; % 3d
cfg.elec_position = elec_position; % 3d
cfg.conductivity = [0.33 1 0.0042 0.33]; 
cfg.dip_orientation = [0,1,0]; % 3d
[u1, u2, u3] = bst_analytical_solution(cfg);
% u1 aniso om; u2 iso om; u3 iso bst
%% RUN FEM
cfg.outputPath = 'G:\My Drive\GitFolders\GitHub\brainstorm-duneuro\matlab_codes\Mesh_generation\BasedOnRoast_Takfa\bst_integration\Anisotropie_newCodes';
cfg.bstDuneuroToolBoxPath = 'G:\My Drive\bst_integration\bst_duneuro_toolbox';
cfg.modality = 'eeg'; % Application for EEG at this level
cfg.lfAvrgRef = 0; % compute average reference 1, otherwise the electrode 1 is the reference and set to 0 
cfg.useTransferMatrix = 1;
cfg.isotrop = 1; % if 0 the anisotropy case will be used.

cfg.head_filename = 'testAniso.msh';
bst_mesh_mat2msh(cfg)

%% 0- Create temporary folder where the data will be saved and processed
if exist(fullfile(cfg.outputPath,'temp')) == 7
    answer = input('A folder named "temp" is already created, do you want to reeplace it ? [y or n] : ',  's' );
    if strcmp(answer,'y')
        mkdir(fullfile(cfg.outputPath,'temp'));
        copyfile(fullfile(cfg.bstDuneuroToolBoxPath,'bin','bst_eeg_transfer.exe'),(fullfile(cfg.outputPath,'temp')),'f')
        copyfile(fullfile(cfg.bstDuneuroToolBoxPath,'bin','bst_eeg_forward.exe'),(fullfile(cfg.outputPath,'temp')),'f')    
    else
        return
    end
else
        mkdir(fullfile(cfg.outputPath,'temp'));
        copyfile(fullfile(cfg.bstDuneuroToolBoxPath,'bin','bst_eeg_transfer.exe'),(fullfile(cfg.outputPath,'temp')),'f')
        copyfile(fullfile(cfg.bstDuneuroToolBoxPath,'bin','bst_eeg_forward.exe'),(fullfile(cfg.outputPath,'temp')),'f')    
end
cd(fullfile(cfg.outputPath,'temp'));

% interface to duneuro
cfg.filename = 'testAniso';
cfg.sourceSpace  = cfg.dip_position; % 3d
cfg.channelLoc  = cfg.elec_position;
addpath(genpath(cfg.bstDuneuroToolBoxPath))
cfg = bst_duneuro_interface(cfg);

u4 = cfg.lf_fem_transfer(find(cfg.dip_orientation),:);


figure;plot(u1,'ro');hold on;plot(u2,'bx');hold on;plot(u3,'ks');hold on;plot(u4,'c>');legend('OM ANI','OM ISO','BST ISO','DN ISO');grid;
figure;plot(zscore(u1),'ro');hold on;plot(zscore(u2),'bx');hold on;plot(zscore(u3),'ks');hold on;plot(zscore(u4),'c>');legend('zs OM ANI','zs OM ISO','zs BST ISO','zs DN ISO');grid;

