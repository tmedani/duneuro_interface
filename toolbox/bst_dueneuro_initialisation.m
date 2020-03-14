function cfg = bst_dueneuro_initialisation(varargin)
% cfg = bst_dueneuro_initialisation(pathOfDuneuroToolbox, pathOfTempOutPut)
% This function will add the bst_duneuro toolbox from pathOfDuneuroToolbox to the matlab path,
% then it creates a temporary folder (temp) on the pathOfTempOutPut, where all the intermediates
% files will be created.
% It also copy the binary file located on the duneuro_toolbox/app to the
% temporary folder.
% If the used want to remove this folder after the computation, he can just change the value of
% cfg.deleteOutputFolder in this function, this value is set to 0;
% Additional configuration options are defined in this function ...
%
% TODO : move the other cfg option to the bst_duneuro_interface.


if nargin == 1
    if isstruct(varargin{1})
        cfg = varargin{1};
        pathOfTempOutPut = varargin{1}.pathOfTempOutPut;
        pathOfDuneuroToolbox = varargin{1}.pathOfDuneuroToolbox;
    else
        error('The input arguments is not correct');
    end
elseif nargin == 2
    pathOfTempOutPut = varargin{1};
    pathOfDuneuroToolbox = varargin{2};
else
    error('The input arguments is not correct');
end
%% *******                                    CONFIGURATION                                                ******* %%

% Add Duneuro toolbox to the matlab path
disp('Adding the brainstrom-duneuro toolbox to Matlab path ...')
addpath(genpath(cfg.pathOfDuneuroToolbox));


% cfg = [];
disp('Setup the configuration parameters ...')
% cfg.outputPath = 'C:\Users\33649\Documents\MATLAB\test_bst_dueneuro_toolbox';
cfg.pathOfTempOutPut = pathOfTempOutPut;

% cfg.bstDuneuroToolBoxPath = 'G:\My Drive\bst_integration\bst_duneuro_toolbox';
cfg.pathOfDuneuroToolbox = pathOfDuneuroToolbox;
cfg.modality = 'eeg'; % Application for EEG at this level

cfg.lfAvrgRef = 0; % compute average reference 1, otherwise the electrode 1 is the reference and set to 0
cfg.useTransferMatrix = 1;
cfg.isotrop = 1; % if 0 the anisotropy case will be used.
cfg.femSourceModel = 'venant' ;% % partial_integration, venant, subtraction ==> check set_minifile
cfg.deleteOutputFolder = 0;
cfg.currentPath = pwd;
cfg.saveCfg = 0;

cfg.writeLogFile = 0;
cfg.logFileName = 'LogFile.txt';

% updat the name
if ~strcmp(cfg.pathOfTempOutPut(end-3:end),'tmp')
    cfg.pathOfTempOutPut = (fullfile(cfg.pathOfTempOutPut,'tmp'))
end

%% 0- Create temporary folder where the data will be saved and processed
if exist(fullfile(cfg.pathOfTempOutPut,'tmp')) == 7
    answer = input('A folder named "temp" is already created, do you want to replace it ? [y or n] : ',  's' );
    if strcmp(answer,'y')
        mkdir(fullfile(cfg.pathOfTempOutPut,'tmp'));
%         copyfile(fullfile(cfg.pathOfDuneuroToolbox,'bin','*'),(fullfile(cfg.pathOfTempOutPut)),'f')
%         disp('Copying of the duneuro binaries to the temporary folder ...')
        if cfg.writeLogFile ==1
            diary((fullfile(cfg.pathOfTempOutPut,cfg.logFileName)))
        end
        
    else
        disp('Aborded ...')
        return
    end
else
    mkdir(fullfile(cfg.pathOfTempOutPut));
%     copyfile(fullfile(cfg.pathOfDuneuroToolbox,'bin','*'),(fullfile(cfg.pathOfTempOutPut)),'f')
%     disp('Copying of the duneuro binaries to the temporary folder ...')
    if cfg.writeLogFile ==1
        diary((fullfile(cfg.pathOfTempOutPut,cfg.logFileName)))
    end
    
end
disp('Copying of the duneuro binaries to the temporary folder ... done')

end