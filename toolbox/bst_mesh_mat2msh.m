function bst_mesh_mat2msh(varargin)
% bst_mesh_mat2msh(cfg)
% this funcion write to folder specified in the filename the msh file
% Inputs :
% cfg.node : liste of node Nnodex3
% cfg.elem : leste of element Nelemx5, the 5th coloumn is the tissu label
% cfg.filename : eithe with extention or not, the output will be with .msh
% Dependencies :  fc_ecriture_fichier_msh(node,elem,Vn,fname)
% Takfarinas MEDANI, November 18th,2019

if nargin == 1
    cfg = varargin{1};
    clear varargin;
end
if nargin > 1
    cfg.node = varargin{1};
    cfg.elem = varargin{2};
    cfg.filename = varargin{3};
    clear varargin;
end
disp('Saving the mesh to MSH format ...')
[filepath,name,ext] = fileparts(cfg.filename);
if isempty(ext) || ~strcmp(ext,'.msh')
    ext = '.msh';
end
filename = [filepath,name,ext];
%Vn = zeros(1,length(cfg.node));
% nnode = [(1:length(cfg.node))' cfg.node];
% nelem = [(1:length(cfg.elem))' cfg.elem];
% free memory
% clear cfg
% fc_ecriture_fichier_msh2(nnode,nelem,Vn,filename);
bst_write_msh_file(cfg.node,cfg.elem,filename)
disp('Saving the mesh to MSH format ... done');
end


