function bst_plotFemMesh(femtemplate, options)
% bst_plotFemMesh(femtemplate, options)
% Adapted version to plot the mesh from the bst structure.
% plotMeshOption. : struct with fields:

% load('four_layer_icbm_bst_low.mat')
% plotMeshOption.CutingPlanEquation= '1*x+0*y+0*z+0>0' %: Equation of the cuttin plan
% plotMeshOption.displayedge= 1;
% plotMeshOption.edgecolor= 'k';
% plotMeshOption.linestyle= '--';
% plotMeshOption.displaynode= 1;
% plotMeshOption.nodestyle= '.';
% plotMeshOption.nodecolor= 'k';
% plotMeshOption.markersize= 10;
% plotMeshOption.displayfacecolor= 1;
% plotMeshOption.facecolor= 'g';
% plotMeshOption.transparency= 1;
% plotMeshOption.facealpha= 0.6000;
% plotMeshOption.plotbrain = 0;
% bst_plotFemMesh(femhead, plotMeshOption);

% TODO : when the pbm of the femtemplate is solved, you should adapt the TissueLabels
% %%%%%
% last modification September 7th 2019
% Created on September 6th 2019 2019
% Takfarinas MEDANI
% medani@usc.edu

DefineTissuColors

plotMeshOption = options;
node = femtemplate.Vertices;
elem =   [femtemplate.Elements femtemplate.Tissue];
%brain =  femtemplate.Vertices;
tissuelabel = femtemplate.TissueLabels; %femtemplate.TissueLabels

tissueId =  sort(unique(femtemplate.Tissue));


% Plot
if ~isfield(plotMeshOption,'CutingPlanEquation')
    figure;
    % Plot the Brain/source space
    if plotMeshOption.plotbrain == 1
        h = plotmesh(brain.Vertices,brain.Faces,...
            'edgecolor','none',...
            'facecolor',grey_clr,...
            'DisplayName','brain');
        hold on;
    end
    % Plot the head
    %for ind = 1 : length(tissuelabel)
    %   id = elem(:,5)==ind;
    h= plotmesh(node,elem,...
        'edgecolor','none',...
        'facecolor',colorScalpSkullScfGmWm(5,:),...
        'DisplayName',tissuelabel{5});
    hold on;
    % display displaynode
    if plotMeshOption.displaynode == 1
        hold on;
        %             [no,~]=removeisolatednode(node,elem(id,:));
        plotmesh(node,[plotMeshOption.nodecolor ...
            plotMeshOption.nodestyle],...
            'markersize',plotMeshOption.markersize);
    end
    %set(0,'defaultLegendAutoUpdate','off');
    % display edge
    if plotMeshOption.displayedge == 1
        set(h, 'edgecolor',plotMeshOption.edgecolor)
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
    %end
    hold off
    %legend show
    set(0,'defaultLegendAutoUpdate','off');   
    
    
else %% using cutting plan
    figure;
    % Plot the Brain/source space
    if plotMeshOption.plotbrain == 1
        h = plotmesh(brain.Vertices,brain.Faces,...
            'edgecolor','none',...
            'facecolor',grey_clr,...
            'DisplayName','brain');
        hold on;
    end
    % Plot the head
    if isfield(plotMeshOption,'tissu')
        if ischar(plotMeshOption.tissu) || isempty(plotMeshOption.tissu)
            if strcmp(plotMeshOption.tissu,'all')
                nb_tissu = length(tissuelabel);
                index = 1:nb_tissu;
            end
        end
    else
        plotMeshOption.tissu = 'all';
        nb_tissu = length(tissuelabel);
        index = 1:nb_tissu;
    end
    if iscell(plotMeshOption.tissu)
        nb_tissu = length(plotMeshOption.tissu);
        A = plotMeshOption.tissu;
        B = tissuelabel;
        index = arrayfun(@(k) find(strncmp(A{k},B,3)), 1:numel(A));
    end
    
    for ind = index(1) : index(end)
        id = elem(:,5)==ind;
        h = plotmesh(node,elem(id,:),...
            plotMeshOption.CutingPlanEquation,...
            'edgecolor','none',...
            'facecolor',colorScalpSkullScfGmWm(ind,:),...
            'DisplayName',tissuelabel{ind});
        % display displaynode
        if plotMeshOption.displaynode == 1
            hold on;
            [no,~]=removeisolatednode(node,elem(id,:));
            plotmesh(node,...
                plotMeshOption.CutingPlanEquation,...
                [plotMeshOption.nodecolor, ...
                plotMeshOption.nodestyle],...
                'markersize',plotMeshOption.markersize);
        end
        % display edge
        if plotMeshOption.displayedge == 1
            set(h, 'edgecolor',plotMeshOption.edgecolor)
            set(h, 'linestyle', plotMeshOption.linestyle) % '-' | '--' | ':' | '-.' | 'none' plotMeshOption,linestyle
        end
        % Facecolor
        if plotMeshOption.displayfacecolor == 2
            set(h, 'facecolor',plotMeshOption.facecolor)
        end
        % Transparency
        if plotMeshOption.transparency == 1
            set(h, 'facealpha',plotMeshOption.facealpha)
        end
        hold on;
    end
    hold off
    %     legend show
    %     set(0,'defaultLegendAutoUpdate','off');
end
end