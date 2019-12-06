clear all; close all ; clc
load('femVSbem_bst_duneuro_cfg_structure.mat')

%% Load the head model

%% 2- Load the source
cfg.sourceSpace

%% 3- Electrode Position


%% 4- Conductivity/tensor


cfg.useTensor = 1;
cfg.isotropic = 0;
cfg.conductivity_radial = [1 1.5 1];
cfg.conductivity_tangential = [1 0.5 0.5];

cfg = bst_define_conductivity_tensor(cfg);


cfg.indElem = 1 : 100;
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
opts.reference_solution = opts.lf_ana_bst;
opts.reference_solution_name = 'Analytic';

opts.computed_solution1 = opts.lf_fem_simbio;
opts.computed_solution1_name = 'SimBio';

opts.computed_solution2 = opts.lf_bem;
opts.computed_solution2_name = 'OpenMeeg';

% select the reference electrode and target electrod
opts.targetElectrode = 3;
opts.referenceElectrode = 2;
opts.referenceModel = 1; % 1 or 2 : ! for average reference electrode, 2 for selecting a reference electrode

bst_display_leadField_row(opts)

% display the solution as box plot 