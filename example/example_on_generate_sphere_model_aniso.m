%% Exapmle on how to use Duneuro toolbox on sphere model with isotropic conductivity
% This script shows how to use the duenruo-brainstorm toolbox on spherical head model
clear all; close all; clc
%% 0 - Install & initialize the brainstrom-duenruo toolbox
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
      cfg = bst_generate_sphere_fem_model(cfg);
end
    
% display the msh  
bst_plot_mesh_advanced(cfg)
bst_plot_mesh_basic(cfg)

%% 2- Load the source
cfg = bst_generate_dipole_in_sphere(cfg);
bst_display_source_space(cfg)
%% 3- Electrode Position
[~, cfg]  = bst_generate_electrode_on_sphere(cfg);
% display electode
bst_display_eeg_hemlet(cfg)
%% 4- Conductivity/tensor
cfg.useTensor = 1;
cfg  = bst_standard_conductivity(cfg);
cfg = bst_define_conductivity_tensor(cfg);
cfg.indElem = 10 : 10;
bst_display_tensor_as_ellipse(cfg)

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
opts.method = 'max';
bst_display_electrical_potential(cfg,opts)


%% Compute performance
opts = [];
opts.reference_solution = cfg.lf_ana_bst;
opts.computed_solution = cfg.lf_fem_simbio;

rdm = bst_compute_rdm(opts);
mag = bst_compute_mag(opts);
err = bst_compute_err(opts);