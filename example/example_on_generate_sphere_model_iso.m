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

cfg.maxvol = 0.001;
cfg.keepratio = 1;
% Spherical head model or realistic head model
cfg.sphereModel = 1;
cfg.sphereRadii = [0.071 0.075 0.080];
%cfg.factor_bst = 0.1;
if cfg.sphereModel == 1
      cfg = bst_generate_sphere_fem_model(cfg);
end    
% display the msh  
bst_plot_mesh_advanced(cfg)
bst_plot_mesh_basic(cfg)

opts.crossPlanName = 'XY'; % string:
opts.crossPlanValue = 0.06;
figure
cfg = bst_display_Mesh2TissuContour(cfg,opts);


opts.axialValue = 0.01;
opts.coronalValue =  0.01;
opts.saggitalValue =  0.01;
cfg = bst_display_MeshContourViewer(cfg,opts);


opts.surfaceIndex = 2;
bst_view_surface_mesh(cfg,opts)

%% 2- Load the source
cfg = bst_generate_dipole_in_sphere(cfg);
bst_display_source_space(cfg)
%% 3- Electrode Position
[~, cfg]  = bst_generate_electrode_on_sphere(cfg);
% display electode
bst_display_eeg_hemlet(cfg)
%% 4- Conductivity/tensor
cfg  = bst_standard_conductivity(cfg);

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
opts.sourceIndex = 24;
opts.lf_to_display = cfg.lf_ana_bst;
opts.method = 'mean';
bst_display_electrical_potential(cfg,opts)


%% Compute performance
opts = [];
opts.reference_solution = cfg.lf_ana_bst;
opts.computed_solution = cfg.lf_fem_transfer;

rdm = bst_compute_rdm(opts);
mag = bst_compute_mag(opts);
err = bst_compute_err(opts);


%% lead field vector : John's code for visualisation
% % finish the code and comment
opts = [];
opts.computed_solution1 = cfg.lf_ana_bst;
opts.computed_solution1_name = 'bst analytical';
opts.computed_solution2 = cfg.lf_bem;
opts.computed_solution2_name = 'OpenMeeg';
opts.computed_solution3 = cfg.lf_fem;
opts.computed_solution3_name = 'Duneuro';
opts.computed_solution4 = cfg.lf_fem_simbio;
opts.computed_solution4_name = 'SimBio';
% select the reference electrode and target electrod
opts.targetElectrode = 3;
opts.referenceElectrode = 2;
opts.referenceModel = 2; % 1 or 2 : ! for average reference electrode, 2 for selecting a reference electrode
bst_display_leadField_vector(cfg,opts)