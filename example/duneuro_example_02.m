%% This script is the final version including all the steps for the duneuro integration
clear all; close all ; clc

%% find the toolbox path
str = which('bst_dueneuro_readme.txt','-all');
[filepath,~,~] = fileparts(str{1});
cfg.pathOfDuneuroToolbox = filepath;
cfg.pathOfTempOutPut = filepath;

%% Intialisation
cfg = bst_dueneuro_initialisation(cfg);


%% 1- Head model
cfg.anatomyPath  = fullfile(cfg.pathOfDuneuroToolbox,'data\defaults\anatomy\ICBM152');
cfg.maxvol = 1;
cfg.numberOfLayer = 3 ; % or 4
cfg.filename = 'test_model' ;
cfg.savefile = 1;
cfg.saveMshFormat = 1 ;
cfg.saveBstFormat = 1 ;
cfg.gmshView = 0;
cfg.plotModel = 1 ;
cfg.plotSource = 0 ;

% Generate head model from the surface files
tic; [node, elem] = bst_generate_volume_head_model(cfg); cfg.timeGenerateVolume = toc;
cfg.elem = elem;  cfg.node = node;
clear elem node
%cfg.listAllParameter = 1;

%% 2- SourceSpace / dipoles position
cfg.sourceSpacePath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
sourceSpace  = load(fullfile(cfg.sourceSpacePath,'tess_cortex_pial_low.mat'),'Vertices');
cfg.sourceSpace = sourceSpace.Vertices;% source location
clear sourceSpace

%% 3- Electrode position
cfg.electrodePath = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\eeg\ICBM152';
cfg.electrodeFile = 'channel_BioSemi_32.mat';
cfg.plotElectrod = 1;
elctrode = load(fullfile(cfg.electrodePath,cfg.electrodeFile));
channelLoc = zeros(length(elctrode.Channel),3);
for ind = 1: length(elctrode.Channel); channelLoc(ind,:) = elctrode.Channel(ind).Loc; end
% Channel location :
cfg.channelLoc = channelLoc;
if cfg.plotElectrod  == 1
    figure; plotmesh(cfg.node,cfg.elem,'facecolor','c','edgecolor','none','facealpha',0.5);
    hold on; plotmesh(cfg.channelLoc,'ko','markersize',12); hold on; plotmesh(cfg.channelLoc,'k.','markersize',16);
    title(['Electrode model : ' cfg.electrodeFile ],'interpreter','none')
end
clear ind elctrode channelLoc

%% 4- Conductivity/tensor
if cfg.isotrop == 1
    % Isotrop
    conductivity = [1 0.2 0.0125 1];
    cfg.conductivity = conductivity;
    clear conductivity
else
    % Anisotrop TODO
    tensor = [];
    cfg.conductivity = tensor;
    clear tensor
end

%% 5- Duneuro-Brainstorm interface
cfg = bst_duneuro_interface(cfg);
% save the configurarion data & results
save('configurationFile','cfg');

%% Load the LF matrix
cfg.lf_fem_transfer;

