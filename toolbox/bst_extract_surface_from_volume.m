function cfg = bst_extract_surface_from_volume(cfg)
%This function will extract the outer surface of a tetrahedral mesh mesh
% The labeling should be from the inner to the outer most surface ...
% otherwise the output will be wrong
% % input
%       cfg.elem; Nelem x 5
%       cfg.node; Nnode x 3
% % OutPut
%     cfg.bemFace{ind} = newface;
%     cfg.bemNode{ind} = newnode;
%     cfg.bemTissu{ind} = cfg.tissu{ind} ;
%     cfg.bemTissuID(ind) = cfg.tissuID(ind);

%% check the input
if ~size(cfg.elem,2) == 5
    error ('The tissu ID are not spesified in the cfg.elem data')
end

if ~isfield(cfg,'numberOfLayer'); cfg.numberOfLayer = length(unique(cfg.elem(:,end)));end

cfg.tissuID = unique(cfg.elem(:,5));

% if isfield(cfg,'tissu') || isfield(cfg,'TissueLabels')
%     for ind = 1 : cfg.numberOfLayer
%         cfg.TissueLabels{ind}  = [ 'tissu_' num2str(cfg.tissuID (ind))];
%         cfg.tissu{ind}  = [ 'tissu_' num2str(cfg.tissuID (ind))];
%     end
%     cfg.tissu = cfg.TissueLabels;
% end

%% extract surface from volume mesh :

for ind = 1 :  cfg.numberOfLayer
    % The labeling should be from the inner to the outer
    % extract the tissuID(1)
    disp(['Extarct the ' cfg.TissueLabels{ind}  ' tissu ... '])
    indTiss = 1:ind;
    idx = (sum((cfg.elem(:,5)==[indTiss]),2));
    [openface,~]=volface(cfg.elem(logical(idx),1:4));
    % check and repair the mesh
    [newnode,newface]=removeisolatednode(cfg.node,openface);
    [newnode,newface]=removedupnodes(newnode,newface);
    [newnode,newface]=surfreorient(newnode,newface);
    opt.dupnode = 1;      opt.duplicated = 1;
    opt.isolated = 1;        opt.meshfix = 1;
    [newnode,newface]=meshcheckrepair(newnode,newface,opt);
    [newface, ~]=meshreorient(newnode,newface);
    
    % Output
    cfg.bemFace{ind} = newface;
    cfg.bemNode{ind} = newnode;
    cfg.bemTissu{ind} = cfg.TissueLabels{ind} ;
    cfg.bemTissuID(ind) = cfg.tissuID(ind);
    
    % check merge
    if 0
        if ind == 1
            [surface_node,surface_face] = mergemesh(newnode,newface);
        else
            [surface_node,surface_face] = mergemesh(surface_node,surface_face,newnode,newface);
        end
        figure;plotmesh(surface_node,surface_face,'x>100');
    end
end

end

