%% 0 - Install & initialize the brainstrom-duenruo toolbox
% - find the brainstrom-duenruo toolbox
str = which('bst_dueneuro_readme.txt','-all');
[filepath,~,~] = fileparts(str{1});
if isempty(filepath); error('brainstorm-duneuro toolbox is not found in this computer'); end 

cfg.pathOfDuneuroToolbox = filepath;
cfg.pathOfTempOutPut = cfg.pathOfDuneuroToolbox;
% - Intialisation
cfg = bst_dueneuro_initialisation(cfg);

%% Examples :
clear all; close all
% example 1 : 
clear all
cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
[node, elem] = bst_generate_volume_head_model(cfg);

% example 2 :
clear all; close all
cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
cfg.maxvol = 0.1;
cfg.keepratio = 1;
cfg.skullThikness = 2 ;
[node, elem] = bst_generate_volume_head_model(cfg);

% example 3 :
clear all; close all
cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
cfg.maxvol = 50;
cfg.keepratio = 1;
cfg.numberOfLayer = 4 ;
cfg.skullThikness = 3 ; 
cfg.saveMshFormat = 1 ;
cfg.saveBstFormat = 1 ;
cfg.saveMatFormat = 1;
cfg.filename = 'test' ; 
cfg.plotModel = 1 ;
cfg.gmshView = 1 ;

cfg.displayComment = 1 ; 
if cfg.numberOfLayer == 4 ;        cfg.tissu =  {'GM','SCF','Skull','Scalp'}; faceColor = ['w','b','g','r']; end
if cfg.numberOfLayer == 3 ;        cfg.tissu =  {'GM','Skull','Scalp',} ; faceColor = ['w','g','r']; end
if cfg.plotModel == 1 ;                  cfg.plotCortex = 1; end
% Generate head model from the surface file
[node, elem] = bst_generate_volume_head_model(cfg);


