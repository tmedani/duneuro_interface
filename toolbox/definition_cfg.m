% %% This file list all the fields on cfg [configuration] structure
% % cfg : is the name of the structure used by the brainstorm_duneuro
% % toolbox. Most of this toolbox's functions use this structure as an input
% % and output argument.
% 
%% Here is the list : not the full list
% modality: string, name of the modality : 'eeg', 'meg', ....
% lfAvrgRef: boolean, use or not the average reference for the eeg leadfield
% useTransferMatrix: boolean, use or not the transfert matrix for the fem
%                   compitqtion
% isotrop: boolean, specify if the model has isotropic or anisotropic
%           conductivity
% anatomyPath: string, specify the path to the anatomy containing the
%               brainstorm surface files 
% maxvol: double, parameter used for the mesh, check surf2mesh
% numberOfLayer: double, number of the lqyer of the head model
% filename: string, the nqme of the head model
% saveMshFormat: boolean, save or not the mesh as MSH format
% saveBstFormat: boolean, save or not the mesh as brainstorm mat format
% gmshView: boolean, will open and display the head model within GMSH
%                   software, only if installed
% plotModel: boolean, will display on matlab the model
% timeGenerateVolume: output, the time spend to generqte the head model
% elem: list of the mesh elements
% node: list of the node elements
% head_filename: the final name of the file of head model = filename +
%                   extension
% sourceSpace: liste of the dipoles 
% electrodePath: path to the file contqining the electrode, bst format
% channelLoc: locqtion of the channeles
% conductivity: vector, with the vqlue of the conductivity, length = nb of
%               layers
% dipole_filename: the name of the dipole file, mainly 'dipole_model.txt'
% electrode_filename: the name of the electrode file, mainly 'electrode_model.txt'
% cond_filename: the name of the conductivity file, 'conductivity_model.con'
% minifile: struct thqt contains all the duneuro parameters
% mini_filename: name of the duneuro configuration file, 'model_minifile.mini'
% lf_fem_transfer: output, the transfert function
% timeDuneuroProcess_transfer: time,
% lf_fem_direct: the lead field matrix
% timeDuneuroProcess_forward: 1.2154e+04
% plotElectrod: plot or not the electrode
% electrodeFile: the channel file name

% This liste will be completed.
% 
