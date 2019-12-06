function bst_plot_mesh_advanced(cfg)
% todo : how to use it and help
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

plotMeshOption = define_plotMeshOption(cfg);
plotTetraMesh(cfg, plotMeshOption);

end