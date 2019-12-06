function femhead = bst_mesh_mat2bst(cfg)
% femhead = bst_NodeElemTissu2bst(node,elem,tissus)
% convert the liste of node and elem to file to bst fem format and save the
% file if the option is activated
% inputs :
% cfg.node : liste of the x,y,z coordinates of the nodes, size Nnodex3
% cfg.elem : liste of the the node, 4 node and the tissu index , size Nelemx5
% cfg.TissueLabels : name of the tissus, size = lenght(uniaue(elem(:,5)))
% cfg.filename : string, name of the output file
% cfg.savefile : boolean, 0 or 1, save the mesh file as the bst format
% dependecies :
% Takfarinas MEDANI 10/09/2019

% covert to the bst format
if isfield(cfg,'filename')
    femhead.Comment = [cfg.filename '_bst_format'];
else
    femhead.Comment =['Model ' num2str(unique(length(elem(:,5)))) ' layers FEM'];
end
femhead.Vertices =   cfg.node;
femhead.Elements =   double(cfg.elem(:,1:4));
femhead.Tissue =     double(cfg.elem(:,5));
if isfield(cfg,'TissueLabels') ||  isfield(cfg,'tissu')
    if isfield(cfg,'TissueLabels')
        femhead.TissueLabels = cfg.TissueLabels;
    else
        femhead.TissueLabels = cfg.tissu;
    end
else
    for ind = 1 : length(unique(femhead.Tissue))
        femhead.TissueLabels{ ind } = ['tissu_' num2str(ind)];
    end
end

femhead.History =     [];

% save the file to hard disc
if cfg.savefile == 1
%     disp('Saving the mesh to BST matlab format ...')
    save(femhead.Comment,'femhead');
%     disp('Saving the mesh to BST matlab format ... done')
end
end