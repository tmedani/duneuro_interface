%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You nedd to export from bst the leadfield computation, the head model,
% the sensor model and the source space, you can compare using John's
% approach 
% export to matlab fem lf as duneuro
% export to matlab bem lf as openmeeg
% export to matlab anal  lf as amalytical

% save('bst_result_3_lf_sph_op_dn','head_model','sensor','dipole')
load('bst_result_3_lf_sph_op_dn','head_model','sensor','dipole','duneuro','openmeeg','analytical')

%% 0 - Install & initialize the brainstrom-duenruo toolbox
% - find the brainstrom-duenruo toolbox
str = which('bst_dueneuro_readme.txt','-all');
[filepath,~,~] = fileparts(str{1});
if isempty(filepath); error('brainstorm-duneuro toolbox is not found in this computer'); end 

cfg.pathOfDuneuroToolbox = filepath;
cfg.pathOfTempOutPut = cfg.pathOfDuneuroToolbox;
% - Intialisation
cfg = bst_dueneuro_initialisation(cfg);

%% head model
cfg.node = head_model.Vertices;
cfg.elem = [head_model.Elements head_model.Tissue];
cfg.TissueLabels = head_model.TissueLabels;
%% sensor model
% 3- Electrode Position
channelLoc = zeros(length(sensor.Channel),3);
for ind = 1: length(sensor.Channel) 
    if ~isempty(sensor.Channel(ind).Loc) % it seem that there is ampty channels... in this example
    channelLoc(ind,:) = sensor.Channel(ind).Loc; 
    else
        channelLoc(ind,:) = []; 
    end
end
% Channel location :
cfg.channelLoc = channelLoc;

%% dipole model
cfg.sourceSpace = dipole.Vertices;

% reference 
analytical.Gain_ref= bst_bsxfun(@minus, analytical.Gain(1:end-1,:), mean(analytical.Gain(1:end-1,:)));
duneuro.Gain_ref= bst_bsxfun(@minus, duneuro.Gain(1:end-1,:), mean(duneuro.Gain));
openmeeg.Gain_ref= bst_bsxfun(@minus, openmeeg.Gain(1:end-1,:), mean(openmeeg.Gain(1:end-1,:)));

%% lead field vector : John's code for visualisation
% % finish the code and comment
opts = [];
opts.computed_solution1 = analytical.Gain_ref(1:end-1,:);
opts.computed_solution1_name = 'Sphere';
opts.computed_solution2 = duneuro.Gain_ref;
opts.computed_solution2_name = 'Duneuro';
opts.computed_solution3 = openmeeg.Gain_ref(1:end-1,:);
opts.computed_solution3_name = 'OpenMeeg';
% select the reference electrode and target electrod
opts.targetElectrode = 3;
opts.referenceElectrode = 2;
opts.referenceModel = 2; % 1 or 2 : ! for average reference electrode, 2 for selecting a reference electrode
bst_display_leadField_vector(cfg,opts)