function cfg = bst_read_channel_file(cfg)
% cfg = bst_read_channel_file(cfg)
% read channel file within brainstorm matlab format

cfg.plotElectrod = 1;
elctrode = load(fullfile(cfg.pathOfElectrodeFile,cfg.electrodeFile));
channelLoc = zeros(length(elctrode.Channel),3);
for ind = 1: length(elctrode.Channel); channelLoc(ind,:) = elctrode.Channel(ind).Loc; end
if cfg.plotElectrod  == 1
    figure; plotmesh(cfg.node,cfg.elem,'facecolor','c','edgecolor','none','facealpha',0.5);
    hold on; plotmesh(channelLoc,'ko','markersize',12); hold on; plotmesh(channelLoc,'k.','markersize',16);
    title(['Electrode model : ' cfg.electrodeFile ],'interpreter','none')
end
% Channel location :
cfg.channelLoc = channelLoc;
end