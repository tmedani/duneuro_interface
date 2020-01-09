function [node, elem] = bst_ft_generate_head_model_hexa(mrifilename,opts)
% generate volume meeh head model hexa
% or tetra by converting the hexa to tetra (no mor information).
% input : mri with the format suported by fieldtrip
%         opts : structure with the 

% shift : value shift for the nodes; used to shift the node the cube of the mesh  ==> recomended is 0.3
% tissus : = structure with the nqme of the tissu to segmente ==>{'gray','white','csf','skull','scalp'}
% coordsys : the coordinate system of the mri ==> ctf if you use the brainstorm mri data 
% output : node, 3D coordinates of the nodes [hexa mesh]  
%           elem, list of the element x 8 and the las coulumn is the
%           tissuID
%           
% opts.tissus;
% opts.coordsys;
% cfg.shift

% Read MRI data 
ft_defaults

% Read MRI data 
mri = ft_read_mri(mrifilename); 

% % Convert to spm coordinate system
% cfg = [];
% cfg.method = 'mni';
% cfg.coordsys = 'ctf';
% cfg.viewresult = 'no';
% mri    = ft_volumerealign(cfg, mri);

% Reslice the volume
cfg     = [];
% cfg.dim = [255 255 255];%mri.dim;
% cfg.resolution = voxsize
mri     = ft_volumereslice(cfg,mri);

% % Visualisation of the reslice volume
% cfg=[];
% figure;
% ft_sourceplot(cfg,mri);

%% Segmentation
cfg           = [];
cfg.output    = opts.tissus;
if isfield(opts,'coordsys');mri.coordsys = opts.coordsys;end
segmentedmri  = ft_volumesegment(cfg, mri);
% display 
seg_i = ft_datatype_segmentation(segmentedmri,'segmentationstyle','indexed');
cfg              = [];
cfg.funparameter = 'seg';
cfg.funcolormap  = lines(6); % distinct color per tissue
cfg.location     = 'center';
cfg.atlas        = seg_i;    % the segmentation can also be used as atlas
ft_sourceplot(cfg, seg_i);

%% Mesh
cfg        = [];
if isfield(cfg,'shift');cfg.shift  = opts.shift;end % 0.3 is recomended
cfg.method = 'hexahedral';
mesh = ft_prepare_mesh(cfg,segmentedmri);

node = mesh.pos;
elem = [mesh.hex mesh.tissue];

%% display the mesh
% convert the mesh to tetr in order to use plotmesh
% [Es0,Vs0,Cs0]=hex2tet(mesh.hex,mesh.pos,mesh.tissue,2);
% node
% display the mesh
% figure;
% plotmesh(Vs0,[Es0 Cs0],'x>50','edgecolor',[50 50 50]/255)
% figure;plotmesh(Vs0,[Es0 Cs0],'x<100','edgecolor',[50 50 50]/255)
end
