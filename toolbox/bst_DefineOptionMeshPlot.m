% PlotOption : Input shoud be controled from the gui

plotMeshOption=[];
%% Parameter that the user can tune
plotMeshOption.tissu = tissu;
% specify the equation of the plan ax+by+cz+d <==> rhs
ax = 00; by = 0; cz =0; d= 0; rhs = 0;
operator = '>' ;% could be <, >, <=, >=;
if (ax+by+cz+d) && ~isempty(operator)
    CutingPlanEquation = ...
        [num2str(ax) '*x+' num2str(by) '*y+' num2str(cz) '*z+' num2str(d) operator  num2str(rhs)];
    plotMeshOption.CutingPlanEquation = CutingPlanEquation;
else
    if isfield(plotMeshOption,'CutingPlanEquation')
        plotMeshOption =  rmfield(plotMeshOption,'CutingPlanEquation');
    end
end

% Display edge (mesh)
displayedge = 0;  edgecolor = 'r'; linestyle ='--' ;% '-' | '--' | ':' | '-.' | 'none'
plotMeshOption.displayedge = displayedge;
plotMeshOption.edgecolor = edgecolor;
plotMeshOption.linestyle = linestyle;
% Display node (mesh); % Format of the node , 
% Node size : markersize option
displaynode = 0;  nodestyle = '.'; % nodestyle : '.','o','*',.. similar as matlab plot
nodecolor = 'k';markersize = 10;
plotMeshOption.displaynode = displaynode;
plotMeshOption.nodestyle = nodestyle;
plotMeshOption.nodecolor = nodecolor;
plotMeshOption.markersize = markersize;

% Facecolor
displayfacecolor = 1; facecolor ='g';
plotMeshOption.displayfacecolor = displayfacecolor;
plotMeshOption.facecolor = facecolor;

% Transparency
transparency = 1;
facealpha = 1;
plotMeshOption.transparency = transparency;
plotMeshOption.facealpha = facealpha;

% plot the brain
plotMeshOption.plotbrain = 0;