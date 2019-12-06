function cfg = bst_compute_lf_bem_openmeeg_eeg(cfg)
% Compute bem solution using the openmeeg from fieldtrip.
% Requirement : Fieldtrip toolbox shold be on the matlab path
% input  : cfg.bemNode 
%                 cfg.bemFace
%                 cfg.conductivity
%                cfg.channelLoc
%                cfg.sourceSpace;
%   output
%   cfg.lf_bem = lf;
%   


if cfg.numberOfLayer ~= 3
    error('OpenMeeg support only 3 layers spheres ... ');
    cfg.lf_bem = [];
end  
disp('Load the surface mesh')
if isfield(cfg,'cfg.bemNode')
    disp('Super the surface mesh is available')
else
     disp('Oups the surface mesh is not available ... I need to extract it from the volume ...')     
     % Extrat the surface
     cfg = bst_extract_surface_from_volume(cfg);     
end

vol_bem = [];
vol_bem.bnd(1).pos = cfg.bemNode{1};
vol_bem.bnd(1).tri = cfg.bemFace{1};
vol_bem.bnd(2).pos = cfg.bemNode{2};
vol_bem.bnd(2).tri = cfg.bemFace{2};
vol_bem.bnd(3).pos = cfg.bemNode{3};
vol_bem.bnd(3).tri = cfg.bemFace{3};

disp('Compute the Volume Conductor')
cfg0=[];
cfg0.method = 'openmeeg';
cfg0.conductivity = cfg.conductivity;
vol_bem = ft_prepare_headmodel(cfg0, vol_bem);

disp('Prepare channels')
sens.elecpos = cfg.channelLoc;
sens.label = {};
nsens = size(sens.elecpos,1);
for i_ch=1:nsens
    sens.label{i_ch} = sprintf('elec%03d', i_ch);
end

% Compute the grid matrix
cfg.grid.pos = cfg.sourceSpace;
cfg.elec = sens;
cfg.headmodel = vol_bem;
        disp('Leadfield Matrix : Computing ')
        grid = ft_prepare_leadfield(cfg);
        lf = cell2mat(grid.leadfield);
%                     lf = [];
%         for ind = 1 : length(grid.leadfield)
%             lf = [lf grid.leadfield{ind}];
%         end
        
        cfg.lf_bem = lf;
end

