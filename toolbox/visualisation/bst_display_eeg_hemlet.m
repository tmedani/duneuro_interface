function  bst_display_eeg_hemlet(cfg)
% cfg.channelLoc

disp('Visualisation du casque')
        triElec = delaunay(cfg.channelLoc(:,1), cfg.channelLoc(:,2), cfg.channelLoc(:,3));% Pour relier les point et former des elemnt volumique
        openface1=volface(triElec);
        
        f15=figure('Color',[1 1 1]);%set(f15,'visible','off');set(f15,'Units','Normalized','Outerposition',[0 0 1 1]);
        p00=plotmesh(cfg.channelLoc,openface1,'FaceColor',[0.8 0.6 0.4],'FaceAlpha',0.3);view(2);
        n=1:length(cfg.channelLoc);
        %nstr=num2str((1:length(cfg.channelLoc)));
        hold on;plotmesh(cfg.channelLoc,'r.','MarkerSize',12)
        %hold on;text(cfg.channelLoc(:,1), cfg.channelLoc(:,2), cfg.channelLoc(:,3),nstr,'FontSize',15)
        set(p00,'EdgeColor','none')
        title('View of the EEG electrodes');
        xlabel('Axe X');ylabel('Axe Y');zlabel('Axe Z');
        legend('Pseudo cap','Electrode','Location','NorthEastOutside')
       %set(v3,'Units','Normalized','Outerposition',[0 0 1 1]);
end