function cfg = bst_compute_lf_fem_simbio_eeg(cfg)

%% FEM Solution based on SimBio
disp('Load the mesh')

[newelem, ~] = meshreorient(cfg.node,cfg.elem(:,1:4));
temp = newelem;
newelem(:,3) = temp (:,4);
newelem(:,4) = temp (:,3);
clear temp;
[newelem, ~] = meshreorient(cfg.node,newelem);
vol_fem = [];
vol_fem.tet = newelem;%elements(:,1:4);
vol_fem.pnt = cfg.node	; % nodes
vol_fem.labels = cfg.elem(:,5);%labels;
vol_fem.tissue = cfg.elem(:,5);
vol_fem.tissuelabel=cfg.tissu;
vol_fem.unit='mm';
vol_fem.cfg=[];
% volume conductor
cfg0              = [];
cfg0.method       = 'simbio';
cfg0.conductivity = cfg.conductivity;

disp('Compute stifness marix the mesh')

% Stifness Matrix
vol_fem = ft_prepare_headmodel(cfg0,vol_fem); % ceuci calcul aussi la matrice de rigidit�


disp('Prepare channels')
sens.elecpos = cfg.channelLoc;
sens.label = {};
nsens = size(sens.elecpos,1);
for i_ch=1:nsens
    sens.label{i_ch} = sprintf('elec%03d', i_ch);
end

disp('Compute Transfert Matrix')

% Transfert Matrix
[transfer] = sb_transfer(vol_fem,sens);% calcul de la matrice de tansfert :)
vol_fem.transfer = transfer;

% Leadfield Matrix
        disp('Leadfield Matrix : Computing ')

[lf, ~] = fc_jv_leadfield_simbio(cfg.sourceSpace, vol_fem);

cfg.lf_fem_simbio = lf;
end
