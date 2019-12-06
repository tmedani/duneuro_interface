function bst_plot_mesh_basic(cfg)

defineTissuColor

if length(unique(cfg.elem(:,5))) == 5
    tissuColor = tissuColor5Layer;
end
if length(unique(cfg.elem(:,5))) == 4
    tissuColor = tissuColor4Layer;
end
if length(unique(cfg.elem(:,5))) == 3
    tissuColor = tissuColor3Layer;
end
figure;
for ind = 1 : length(unique(cfg.elem(:,5)))
    id = cfg.elem(:,5)==ind;
    plotmesh(cfg.node,cfg.elem(id,:),...
        'x>0',...
        'edgecolor','k',...
        'facecolor',tissuColor(ind,:));
    hold on;
end
legend(cfg.tissu)
xlabel('x');ylabel('y');zlabel('z');
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% set(gca,'ZTick',[])
grid on; grid minor; 
end