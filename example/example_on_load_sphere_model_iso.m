%% Exapmle on how to use Duneuro toolbox on sphere model with isotropic conductivity
% This script shows how to use the duenruo-brainstorm toolbox on spherical head model
clear all; close all; clc
%% 0 - Install & initialize the brainstrom-duenruo toolbox
% - find the brainstrom-duenruo toolbox
str = which('bst_dueneuro_readme.txt','-all');
[filepath,~,~] = fileparts(str{1});
if isempty(filepath); error('brainstorm-duneuro toolbox is not found in this computer'); end

cfg.pathOfDuneuroToolbox = filepath;
cfg.pathOfTempOutPut = cfg.pathOfDuneuroToolbox;
% - Intialisation
cfg = bst_dueneuro_initialisation(cfg);

%% 1 - Head Model
% Load head model or create head model
cfg.loadModel = 0;
% Spherical head model or realistic head model
cfg.sphereModel = 1;
if cfg.sphereModel == 1
    disp('Loading of the matlab Model from hard disc')
    load(fullfile(cfg.pathOfDuneuroToolbox,'data','duneuro_model.mat'));
    disp('Loading of the matlab Model from hard disc ... done')
    % else
    %      cfg = bst_generate_sphere_fem_model(cfg)
end

cfg.node = model.volume.node;cfg.elem = model.volume.elem;
cfg.tissu = model.tissus; cfg.tissuLabel = model.tissus_id;
cfg.sphereCenter = model.center;    cfg.sphereRadii  = model.radii;

% display the msh
bst_plot_mesh_advanced(cfg)
bst_plot_mesh_basic(cfg)

%% 2- Load the source
cfg.sourceSpace = model.source;
% display source space
bst_display_source_space(cfg)

%% 3- Electrode Position
cfg.channelLoc  = model.elec_on_node;
% display electode
bst_display_eeg_hemlet(cfg)
%% 4- Conductivity/tensor
cfg.conductivity = model.conductivity;
cfg.useTensor = 1;
if cfg.useTensor == 1
    cfg  = bst_standard_conductivity(cfg);
    
    % cfg.isotrop = 1;
    cfg = bst_define_conductivity_tensor(cfg);
    cfg.indElem = 1 : 500;
    bst_display_tensor_as_ellipse(cfg)
end
%% 5- Lead Field computation
%% 5a- Analytical solution in the case of sphere
cfg = bst_compute_lf_analytical(cfg);

%% 6b- FEM Duneuro/ via Brainstorm interface
cfg = bst_duneuro_interface(cfg);

%% === > Only if the Fieldtrip toolbox is installed and the SimBio dependecies installed
%% 6c- FEM SimBio / via fieldtrip interface
cfg = bst_compute_lf_fem_simbio_eeg(cfg);

%% 6d- BEM OpenMeeg/ via fieldtrip interface (only for three layers)
cfg = bst_compute_lf_bem_openmeeg_eeg(cfg);

%% Visulation of the electrical potential
opts = [];
opts.sourceIndex = 'all';
opts.lf_to_display = cfg.lf_ana_bst;
opts.method = 'mean';
bst_display_electrical_potential(cfg,opts)

%% 7 - Display leadField & results
% On the EEG hemlet :
% TODO
%% Visualisation du casque à electrode
bst_display_eeg_hemlet(cfg)

%% Visulation of the electrical potential
opts.sourceIndex = 10 :25;
opts.lf_to_display = cfg.lf_ana_bst;
bst_display_electrical_potential(cfg,opts)

%% Compute performance
opts = [];
opts.reference_solution = cfg.lf_ana_bst;
opts.computed_solution = cfg.lf_fem_transfer;

rdm = bst_compute_rdm(opts);
mag = bst_compute_mag(opts);
err = bst_compute_err(opts);

%% Compute performance
opts = [];
opts.reference_solution = cfg.lf_ana_bst;
opts.computed_solution = cfg.lf_fem_transfer;

rdm = bst_compute_rdm(opts);
mag = bst_compute_mag(opts);
err = bst_compute_err(opts);

%% Visualisation of the leadfield
opts.reference_solution = cfg.lf_ana_bst;
opts.reference_solution_name = 'Analytic';
opts.computed_solution1 = cfg.lf_fem_transfer;
opts.computed_solution1_name = 'Duneuro';
opts.computed_solution2 = cfg.lf_bem;
opts.computed_solution2_name = 'OpenMeeg';

bst_display_leadField_graph(opts)

%% lead field vector : John's code for visualisation
% % finish the code and comment
opts.reference_solution = cfg.lf_ana_bst;
opts.reference_solution_name = 'Analytic';
opts.computed_solution = cfg.lf_fem_transfer;
opts.computed_solution_name = 'Duneuro';
opts.computed_solution2 = cfg.lf_bem;
opts.computed_solution2_name = 'OpenMeeg';
% select the reference electrode and target electrod
opts.targetElectrode = 3;
opts.referenceElectrode = 2;
opts.referenceModel = 2; % 1 or 2 : ! for average reference electrode, 2 for selecting a reference electrode
bst_display_leadField_vector(cfg,opts)