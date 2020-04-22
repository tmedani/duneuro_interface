function dn_plotmesh(node,varargin)
% adapted verion of plotmesh that can displays hexa mesh.

if size(varargin{1},2)>5
    if size(varargin{1},2) == 9
        tissues = double(varargin{1}(:,9));
    else
        tissues = ones(size(varargin{1},1),1);
    end
   [tetraElem,tetraNode,tetraLabel] = hex2tet(double(varargin{1}(:,1:8)), node, tissues, 3);
   node = tetraNode; 
   varargin{1} = [tetraElem tetraLabel];
end

plotmesh(node,varargin)

end