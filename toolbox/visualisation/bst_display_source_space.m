function  bst_display_source_space(cfg)
% cfg.channelLoc

disp('Visualisation du casque')
        triElec = delaunay(cfg.sourceSpace(:,1), cfg.sourceSpace(:,2), cfg.sourceSpace(:,3));% Pour relier les point et former des elemnt volumique
        openface1=volface(triElec);
        
        f15=figure('Color',[1 1 1]);%set(f15,'visible','off');set(f15,'Units','Normalized','Outerposition',[0 0 1 1]);
        p00=plotmesh(cfg.sourceSpace,openface1,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.3);view(2);
%         n=1:length(cfg.sourceSpace);
        %nstr=num2str((1:length(cfg.channelLoc)));
        hold on;plotmesh(cfg.sourceSpace,'ro','MarkerSize',10)
        hold on;plotmesh(cfg.node,cfg.elem,'FaceAlpha',0.1,'EdgeColor','none')

        %hold on;text(cfg.channelLoc(:,1), cfg.channelLoc(:,2), cfg.channelLoc(:,3),nstr,'FontSize',15)
        set(p00,'EdgeColor',[0.8 0.8 0.8])
        title('View of the Source Space');
        xlabel('Axe X');ylabel('Axe Y');zlabel('Axe Z');
        legend('PseudoCortex','Dipole','Location','NorthEastOutside')
       %set(v3,'Units','Normalized','Outerposition',[0 0 1 1]);
end