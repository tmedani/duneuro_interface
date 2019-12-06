clear all 
bstElectrodePath = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\eeg\ICBM152';
brain  = load('tess_gm.mat');
opts.decimate_cortex = 1; % reduce the number of source
opts.under_node_or_face = 1; % 1 for node and 0 for face
opts.source_depth = -1; % mm
opts.keepratio = 0.1214;

[dip_pos, dip_ori] = bst_generate_source_space(brain,opts);