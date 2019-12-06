clear all; close all ; clc

%% find the toolbox path
str = which('bst_dueneuro_readme.txt','-all');
[filepath,~,~] = fileparts(str{1});
cfg.pathOfDuneuroToolbox = filepath;
cfg.pathOfTempOutPut = filepath;

%% Intialisation
cfg = bst_dueneuro_initialisation(cfg);

%% 1 -Load the head model
cfg.sphereModel = 1;
if cfg.sphereModel == 1
    load(fullfile(cfg.pathOfDuneuroToolbox,'data','duneuro_model.mat'));
end
cfg.node = model.volume.node;cfg.elem = model.volume.elem;
cfg.tissu = model.tissus; cfg.tissuLabel = model.tissus_id;

% Type of model : Spherical head model or realistic.
if isfield(model,'radii'); cfg.sphereModel = 1; end
if cfg.sphereModel == 1
    cfg.sphereCenter = model.center;    cfg.sphereRadii  = model.radii;
end

% display the msh
bst_plot_mesh_advanced(cfg)
bst_plot_mesh_basic(cfg)

%% 2- Load the source
cfg.sourceSpace = model.source;
bst_display_source_space(cfg)

%% 3- Electrode Position
cfg.channelLoc  = model.elec_on_node;
bst_display_eeg_hemlet(cfg)
[~, cfg]  = bst_generate_electrode_on_sphere(cfg);
% display electode
bst_display_eeg_hemlet(cfg)


%% 4- Conductivity/tensor
cfg.conductivity = model.conductivity;


cfg.useTensor = 1;
cfg.isotropic = 0;
cfg.conductivity_radial = [1 1.5 1];
cfg.conductivity_tangential = [1 0.5 0.5];

cfg = bst_define_conductivity_tensor(cfg);


cfg.indElem = 1 : 1000;
bst_display_tensor_as_ellipse(cfg)

bst_display_tensor_as_vector(cfg)

% TODO : add function to compute the anisotrpy measure ... FA, MA, ....
%% 5- ----- Lead FIeld Computation --------%%

%% 5a- Analytical solution in the case of sphere
cfg = bst_compute_lf_analytical(cfg);

%% 6b- FEM Duneuro/ via Brainstorm interface
cfg = bst_duneuro_interface(cfg);

%% 6c- FEM SimBio / via fieldtrip interface
cfg = bst_compute_lf_fem_simbio_eeg(cfg);

%% 6d- BEM OpenMeeg/ via fieldtrip interface (only for three layers)
cfg = bst_compute_lf_bem_openmeeg_eeg(cfg);

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
opts.computed_solution = cfg.lf_fem_simbio;

rdm = bst_compute_rdm(opts);
mag = bst_compute_mag(opts);
err = bst_compute_err(opts);

%% lead field vector : John's code for visualisation
% % finish the code and comment
opts.reference_solution = cfg.lf_ana_bst;
opts.reference_solution_name = 'Analytic';

opts.computed_solution1 = cfg.lf_fem_transfer;
opts.computed_solution1_name = 'Duneuro';

opts.computed_solution2 = opts.lf_bem;
opts.computed_solution2_name = 'OpenMeeg';

opts.computed_solution3 = opts.lf_fem_transfer;
opts.computed_solution3_name = 'Duneuro';

% select the reference electrode and target electrod
opts.targetElectrode = 3;
opts.referenceElectrode = 2;
opts.referenceModel = 2; % 1 or 2 : 1 for average reference electrode, 2 for selecting a reference electrode

bst_display_leadField_vector(cfg,opts)

% display the solution as box plot
