function bst_plotTetraMesh(cfg, plotMeshOption)

node = cfg.node;
elem = cfg.elem;
tissuelabel = cfg.tissu; % string of names

if length(cfg.tissu) == 3
    tissuColor = plotMeshOption.tissuColor5Layer ;
end
if length(cfg.tissu) == 4
    tissuColor = plotMeshOption.tissuColor4Layer ;
end

if length(cfg.tissu) == 5
    tissuColor = plotMeshOption.tissuColor5Layer ;
end

% todo : add the brain for next

if ~isfield(plotMeshOption,'CutingPlanEquation')
    h = figure;
    % Plot the Brain/source space
    %     if plotMeshOption.plotbrain == 1
    %         h = plotmesh(brain.Vertices,brain.Faces,...
    %             'edgecolor','none',...
    %             'facecolor',grey_clr,...
    %             'DisplayName','brain');
    %         hold on;
    %     end
    % Plot the head
    for ind = 1 : length(tissuelabel)
        id = elem(:,5)==ind;
        h = plotmesh(node,elem(id,:),...
            'edgecolor','none',...
            'facecolor',tissuColor(ind,:),...
            'DisplayName',tissuelabel{ind});
        hold on;
        
        
        % display displaynode
        if plotMeshOption.displaynode == 1
            hold on;
            h = plotmesh(node,[plotMeshOption.nodecolor ...
                plotMeshOption.nodestyle],...
                'markersize',plotMeshOption.markersize);
        end
        set(0,'defaultLegendAutoUpdate','off');
        % display edge
        if plotMeshOption.displayedge == 1
            %        set(h, 'edgecolor',plotMeshOption.edgecolor)
            set(h, 'linestyle', plotMeshOption.linestyle) % '-' | '--' | ':' | '-.' | 'none' plotMeshOption,linestyle
        end
        % Facecolor
        if plotMeshOption.displayfacecolor == 1
            set(h, 'facecolor',plotMeshOption.facecolor)
        end
        % Transparency
        if plotMeshOption.transparency == 1
            set(h, 'facealpha',plotMeshOption.facealpha)
        end
    end
    hold off
    legend show
    set(0,'defaultLegendAutoUpdate','off');
else %% not using cutting plan
    h = figure;
    %     % Plot the Brain/source space
    %     if plotMeshOption.plotbrain == 1
    %         h = plotmesh(brain.Vertices,brain.Faces,...
    %             'edgecolor','none',...
    %             'facecolor',grey_clr,...
    %             'DisplayName','brain');
    %         hold on;
    %     end
    % Plot the head
    for ind = 1 : length(tissuelabel)
        id = elem(:,5)==ind;
        h = plotmesh(node,elem(id,:),...
            plotMeshOption.CutingPlanEquation,...
            'edgecolor','none',...
            'facecolor',tissuColor(ind,:),...
            'DisplayName',tissuelabel{ind});
        hold on;
        
        
        % display edge
        if plotMeshOption.displayedge == 1
            set(h, 'edgecolor',plotMeshOption.edgecolor)
            set(h, 'linestyle', plotMeshOption.linestyle) % '-' | '--' | ':' | '-.' | 'none' plotMeshOption,linestyle
        end
        % display displaynode
        if plotMeshOption.displaynode == 1
            hold on;
            h = plotmesh(node,plotMeshOption.CutingPlanEquation,...
                [plotMeshOption.nodecolor ...
                plotMeshOption.nodestyle],...
                'markersize',plotMeshOption.markersize);
        end
        % Facecolor
        if plotMeshOption.displayfacecolor == 2
            set(h, 'facecolor',plotMeshOption.facecolor)
        end
        % Transparency
        if plotMeshOption.transparency == 1
            set(h, 'facealpha',plotMeshOption.facealpha)
        end
    end
    hold off
    legend show
    set(0,'defaultLegendAutoUpdate','off');
end

end