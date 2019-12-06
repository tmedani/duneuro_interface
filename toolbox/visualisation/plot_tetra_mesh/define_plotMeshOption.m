function plotMeshOption = define_plotMeshOption(cfg)

% This function should me modified from outside in the next version

% Adapted version to plot the mesh from the bst structure.
% plotMeshOption : struct with fields:

% CutingPlanEquation: '1*x+0*y+0*z+0>0' : Eqution of the cuttin plan
% displayedge: 1
%   edgecolor: 'k'
%   linestyle: '--'
% displaynode: 1
%   nodestyle: '.'
%   nodecolor: 'k'
%   markersize: 10
% displayfacecolor: 1
%   facecolor: 'g'
% transparency: 1
%   facealpha: 0.6000

% TODO : when the pbm of the femtemplate is solved, you should adapt the TissueLabels
% %%%%%
% last modification September 7th 2019
% Created on September 6th 2019 2019
% Takfarinas MEDANI
% medani@usc.edu


plotMeshOption=[];
defineTissuColor


plotMeshOption.skin_clr   = [255 213 119]/255;
plotMeshOption.bone_clr  = [140  85  85]/255;
plotMeshOption.csf_clr     = [202 50 150]/255;
plotMeshOption.grey_clr   = [150 150 150]/255;
plotMeshOption.white_clr  = [250 250 250]/255;

plotMeshOption.tissuColor5Layer = tissuColor5Layer;
plotMeshOption.tissuColor4Layer =tissuColor4Layer;
plotMeshOption.tissuColor3Layer = tissuColor3Layer;
%% Parameter that the user can tune
% Plotting the mesh
% specify the equation of the plan ax+by+cz+d 'operator' rhs  ; operator
% could be either =, < or >
% Input shoud be controled from the gui

ax = 1; by = 0; cz =0; d= 0;
operator = '>' ;% could be <, >, <=, >=;
rhs = mean(cfg.node(1,:));
if ~(ax*by*cz*d) && ~isempty(operator)
    CutingPlanEquation = ...
        [num2str(ax) '*x+' num2str(by) '*y+' num2str(cz) '*z+' num2str(d) operator  num2str(rhs)];
    plotMeshOption.CutingPlanEquation = CutingPlanEquation;
else
    if isfield(plotMeshOption,'CutingPlanEquation')
        plotMeshOption =  rmfield(plotMeshOption,'CutingPlanEquation');
    end
end

% Display edge (mesh)
displayedge = 1;  edgecolor = 'k'; linestyle ='--' ;% '-' | '--' | ':' | '-.' | 'none'
plotMeshOption.displayedge = displayedge;
plotMeshOption.edgecolor = edgecolor;
plotMeshOption.linestyle = linestyle;
% Display node (mesh); % Format of the node , % nodestyle : '.','o','*',.. similar as matlab plot
% Node size : markersize option
displaynode = 0;  nodestyle = '.';  nodecolor = 'k';markersize = 10;
plotMeshOption.displaynode = displaynode;
plotMeshOption.nodestyle = nodestyle;
plotMeshOption.nodecolor = nodecolor;
plotMeshOption.markersize = markersize;

% Facecolor
displayfacecolor = 1;
facecolor ='g';
plotMeshOption.displayfacecolor = displayfacecolor;
plotMeshOption.facecolor = facecolor;

% Transparency
transparency = 1;
plotMeshOption.transparency = transparency;
facealpha = 0.6;
plotMeshOption.facealpha = facealpha;

% plot the brain
plotMeshOption.plotbrain =1;

end