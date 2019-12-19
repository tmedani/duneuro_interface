% convert brainstorm mri to nii
sMri = 'subjectimage_BCI-DNI_brain.mat';
OutputFile = 'subjectimage_BCI-DNI_brain.nii';

bst_mri_mat2nii(sMri,OutputFile)

% generate hexa mesh 
opts.tissus = {'gray','white','csf','skull','scalp'};
% opts.coordsys = 'ctf'; % use fieldtrip names
% cfg.shift = 0.3;

mrifilename = 'MNI152_T1_1mm.nii' ;opts.coordsys = 'mni';
[node, elem] = bst_ft_generate_head_model_hexa(mrifilename,opts);

%% display the mesh
% convert the mesh to tetr in order to use plotmesh
% [Es,Vs,Cs]=hex2tet(elem(:,1:8),node,elem(:,end),2);
% figure;
% plotmesh(Vs,[Es Cs],'x<50','edgecolor',[50 50 50]/255)