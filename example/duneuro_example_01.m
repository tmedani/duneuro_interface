%% How to use Duneuro toolbox with system call (Linux-Windows-[MAC?] )
clear all; close all; clc;

%% 0 - Initialisation
cfg = [];
% a- First of all you need to specify the path where you have the
% bst_duneuro_toolbox, it will be added to the path.

pathOfTempOutPut= 'C:\Users\33649\Documents\MATLAB\test_bst_dueneuro_toolbox';
% b- You need also to specify the output folder, where all the intermediate
% data will be saved (input and output)
pathOfDuneuroToolbox= 'G:\My Drive\bst_integration\bst_duneuro_toolbox';
% c- Initialisation of duneuro toolbox
cfg = bst_dueneuro_initialisation(cfg);
clear pathOfDuneuroToolbox  pathOfTempOutPut

%% 1- Head Model
% The information related to the head model, mainly the liste of node and
% with the 3 D cartisian coordinates Nnode * [x, y ,z] , the liste of the element (tetra for this version),
% the liste of the lement includes the label or the id of the element,
% therefore the format will be  Nelem * [n1 n2 n3 n4 id].
% For more detail, user can also add the tissu label as a string.
% -- Here I will use a structure where many information are stored
cfg.loadModel = 0; % if 1, you should use the model structure defined in the begining of the project
                              % if 0, it will generate a volume mesh from
                              % the surface files defined on the
                              % data/anatomy or any othe brainstorm surface
                              % files.
if cfg.loadModel == 1 % load a model,
    load(fullfile(cfg.pathOfDuneuroToolbox,'data','duneuro_model.mat'))
    cfg.elem =  model.volume.elem; cfg.node =  model.volume.node;
else % generate a model from surfaces
    cfg.anatomyPath  = fullfile(cfg.pathOfDuneuroToolbox,'data\defaults\anatomy\ICBM152');
%    cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
    cfg = bst_generate_volume_head_model(cfg);
end
% Display model TODO
% bst_display_mesh(cfg)

%% 2- SourceSpace / dipoles position
% The same format as the node, soo, just a liste of 3D coordinates Nsource * [x, y ,z]
% Either read the output cortex of the CAT/SPM segmentation or generate new cortex nodes 
if cfg.loadModel == 1
    cfg.sourceSpace = model.source; 
else% source location
cfg.pathOfSourceSpace  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
sourceSpace  = load(fullfile(cfg.pathOfSourceSpace,'tess_cortex_pial_low.mat'),'Vertices');
cfg.sourceSpace = sourceSpace.Vertices;% source location
clear sourceSpace; 
end

%% 3- Electrode position
% Channel location : 3D coordinates Nelec * [x, y ,z]
if cfg.loadModel == 1
cfg.channelLoc = model.elec_on_node;
else % Read the channel file 
cfg.pathOfElectrodeFile = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\eeg\ICBM152';
cfg.electrodeFile = 'channel_BioSemi_32.mat';
cfg = bst_read_channel_file(cfg);
end
% display channel
if cfg.plotElectrod  == 1
    figure; plotmesh(cfg.node,cfg.elem,'facecolor','c','edgecolor','none','facealpha',0.5);
    hold on; plotmesh(cfg.channelLoc,'ko','markersize',12); hold on; plotmesh(cfg.channelLoc,'k.','markersize',16);
    title(['Electrode model : ' cfg.electrodeFile ],'interpreter','none')
end
clear ind elctrode channelLoc

%% 4- Conductivity/tensor
% isotropic model : vector, one valu per tissu / anosotrpic : Nelem x [c11 c22 c33 c12 c13 c23];
if cfg.isotrop == 1
    if cfg.loadModel == 1
        cfg.conductivity = model.conductivity;
    elseif cfg.numberOfLayer == 4 
        cfg.conductivity = [1 0.025 0.33 1]; % not real value
        elseif cfg.numberOfLayer == 3 
        cfg.conductivity = [1 0.025 1];
    end
else
    % Anisotrop TODO
    tensor = [];
    cfg.conductivity = tensor;
    clear tensor
end
    
%% 5- Duneuro-Brainstorm interface
cfg = bst_duneuro_interface(cfg);

%% 6- Read the lead field
lf = cfg.lf_fem_transfer;

%% 7- Save the configuration & results data
%  save the cfg structure
if cfg.saveCfg == 1
    save(['configurationData_'  cfg.filename ],'cfg');
end
%% Display LeadField : John Mosher function's
