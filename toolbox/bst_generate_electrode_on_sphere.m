function [elec_position, cfg] = bst_generate_electrode_on_sphere(cfg)
% cfg.node;
% cfg.elem;
% cfg.nb_electrode;
% Extract surfaces nodes
if ~isfield(cfg,'nb_electrode'); cfg.nb_electrode = 64; end
[openface,~]=volface(cfg.elem(:,1:4));
[no,el]=removeisolatednode(cfg.node,openface);
elec_position = no(randperm(length(no),cfg.nb_electrode),:);

if ~isfield(cfg,'plotElectrode'); cfg.plotElectrode = 1; end

if cfg.plotElectrode == 1
figure; 
plotmesh(no,el,'facecolor','c','edgecolor','none');
hold on; plotmesh(elec_position,'ko');
hold on; plotmesh(elec_position,'k+');
end

cfg.channelLoc = elec_position;
end