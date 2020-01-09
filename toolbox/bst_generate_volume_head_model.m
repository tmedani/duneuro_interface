function varargout = bst_generate_volume_head_model(varargin)
% cfg = bst_generate_volume_head_model(cfg)
% [node, elem] = bst_generate_volume_head_model(varargin)
% This function is used to generate (& save if specified) a volume mesh from surface mesh.
% This version v1 support these arguments :
% if varargin coud be a string or a matlab structure.
% if varargin is a string, this should be the name of the brainstorm anatomy path
% if varargin is a structure with the folowing fields :
% Mandatory parameters:
% cfg.anatomyPath : the path to anatomy folder. This folder should contains the brainstorm surface files.
%                               head  : 'tess_head.mat'
%                               inner  : 'tess_innerskull.mat'
%                               outer  : 'tess_outerskull.mat'
%                               these three surface files are mandatory and should  be available in the  path
% cfg.maxvol : maximum volume of the element, see iso2mesh for more details
% cfg.keepratio : factor that keeps the original surface nodes,  see iso2mesh for more details
%
% Optional parameters
% cfg.numberOfLayer : The number of layers of the output model (default = 4)
% cfg.skullThikness : The thickness of the skull head model  (default = 3)
% cfg.saveMshFormat : either 0 or 1,  save the mesh as msh (GMSH FORMAT)
% cfg.saveBstFormat : either 0 or 1, save the mesh with the brainstorm volume format
% cfg.filename : The name of the outpu file
% cfg.tissu = {'Scalp','Skull','CSF','WM'}
% cfg.displayComment : either 1 or 0
% cfg.gmshView : diplay the msh format with Gmsh
% Dependencies :
%This function calls the surf2mesh of iso2mesh
%%
% % Examples :
% clear all; close all
% % example 1 :
% clear all
% cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
% [node, elem] = bst_generate_volume_head_model(cfg.anatomyPath);
%
% % example 2 :
% clear all; close all
% cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
% cfg.maxvol = 0.1;
% cfg.keepratio = 1;
% [node, elem] = bst_generate_volume_head_model(cfg);
%
% % example 3 :
% clear all; close all
% cfg.anatomyPath  = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
% cfg.maxvol = 50;
% cfg.keepratio = 1;
% cfg.numberOfLayer = 4 ;
% cfg.skullThikness = 3 ;
% cfg.saveModel = 1 ;
% cfg.saveMshFormat = 1 ;
% cfg.saveBstFormat = 1 ;
% cfg.saveMatFormat = 1;
% cfg.saveCauFormat = 1; % Cauchy format
% cfg.filename = 'test' ;
% cfg.plotModel = 1 ;
% cfg.displayComment = 1 ;
% if cfg.numberOfLayer == 4 ;        cfg.tissu =  {'GM','SCF','Skull','Scalp'}; faceColor = ['w','b','g','r']; end
% if cfg.numberOfLayer == 3 ;        cfg.tissu =  {'GM','Skull','Scalp',} ; faceColor = ['w','g','r']; end
% if cfg.plotModel == 1 ;                  cfg.plotCortex = 1; end
% % Generate head model from the surface file
% [node, elem] = bst_generate_volume_head_model(cfg);

% Takfarinas MEDANI
% version v1, November 18th , 12:30 PM.


%% Check the class of input parameters
% If the user specify only the anatomy path
% This option ask to generate the volume mesh from the surface files in the
% varargin{1} folder.

if ischar(varargin{1})
    cfg.anatomyPath = varargin{1};
elseif isstruct(varargin{1})
    cfg = varargin{1};
end


%% Check the input argument cfg
if ~isfield(cfg,'anatomyPath')
    error(sprintf(' Anatomy path is not specified.\n Please provide the brainstorm anatomy path to cfg.anatomyPath as a string ') );
end
if ~isfield(cfg,'maxvol')
    disp(sprintf(['Mesh resolution parameters are not specified.\n'...
        'Please check cfg.maxvol \n'...
        'We will use default parameter  : cfg.maxvol = 1 ']));
    cfg.maxvol = 1;
end
if  ~isfield(cfg,'keepratio')
    disp(sprintf(['Mesh resolution parameters are not specified.\n'...
        'Please check  cfg.keepratio \n'...
        'We will use default parameter  : cfg.keepratio = 1']));
    cfg.keepratio = 1;
end
%% Check if the user specified value for the optional parameters
if ~isfield(cfg,'numberOfLayer');  cfg.numberOfLayer = 4 ; end
if ~isfield(cfg,'skullThikness');     cfg.skullThikness = 3 ; end
if ~isfield(cfg,'saveModel');  cfg.saveFormat = 0 ; end
if ~isfield(cfg,'saveMshFormat');  cfg.saveMshFormat = 0 ; end
if ~isfield(cfg,'saveBstFormat');   cfg.saveBstFormat = 0 ; end
if ~isfield(cfg,'saveMatFormat');   cfg.saveMatFormat = 0 ; end
if ~isfield(cfg,'saveCauFormat');   cfg.saveCauFormat = 0 ; end
if ~isfield(cfg,'saveModel');   cfg.saveModel= 0 ; end
if ~isfield(cfg,'filename');              cfg.filename = 'fem_mesh_model' ; end
if ~isfield(cfg,'plotModel');            cfg.plotModel = 1 ; end
if ~isfield(cfg,'plotSource');            cfg.plotSource = 0 ; end
if ~isfield(cfg,'isotrop');            cfg.isotrop = 0 ; end
if cfg.numberOfLayer == 4 ;        cfg.TissueLabels =  {'GM','SCF','Skull','Scalp'}; faceColor = ['w','b','g','r']; end
if cfg.numberOfLayer == 3 ;        cfg.TissueLabels =  {'GM','Skull','Scalp',} ; faceColor = ['w','g','r']; end
if ~isfield(cfg,'displayComment'); cfg.displayComment = 1 ; end
if cfg.plotModel == 1 ;                  cfg.plotCortex = 1; end
if ~isfield(cfg,'gmshView');            cfg.gmshView = 0 ; end
if cfg.isotrop == 0;  cfg.saveCauFormat = 1; end
if cfg.isotrop == 1
    % Duneuro uses the msh file
    cfg.head_filename = [cfg.filename '.msh'];
else
    % Duneuro uses the Cauchy files
    cfg.head_filename = [cfg.filename '.geo'];
end

if ~isfield(cfg,'saveModel')
    if cfg.saveMshFormat + cfg.saveBstFormat + cfg.saveMatFormat + cfg.saveCauFormat > 0
        cfg.saveModel = 1;
    end
end
%% 1- Check and load the surfaces
% Load the head surface
if exist(fullfile(cfg.anatomyPath,'tess_head.mat')) == 2
    if(cfg.displayComment == 1);  disp(' Loading scalp surface ... '); end
    head  = load(fullfile(cfg.anatomyPath,'tess_head.mat'));
else
    error('tess_head.mat does not exist' );
end
% Load the outer skull surface
if exist( fullfile(cfg.anatomyPath,'tess_outerskull.mat')) == 2
    if(cfg.displayComment == 1);  disp(' Loading outer skull surface ... '); end
    outer  = load(fullfile(cfg.anatomyPath,'tess_outerskull.mat'));
else
    error('tess_outerskull.mat does not exist' );
end
% Load the inner skull surface
if exist( fullfile(cfg.anatomyPath,'tess_innerskull.mat')) == 2
    if(cfg.displayComment == 1);  disp(' Loading inner skull surface ... '); end
    inner  = load(fullfile(cfg.anatomyPath,'tess_innerskull.mat'));
else
    error('tess_innerskull.mat does not exist' );
end
% load the cortex
if cfg.plotCortex == 1
    if exist( fullfile(cfg.anatomyPath,'tess_cortex_pial_low.mat')) == 2
        if(cfg.displayComment == 1);  disp(' Loading tess_cortex_pial_low surface ... '); end
        brain  = load(fullfile(cfg.anatomyPath,'tess_cortex_pial_low.mat'));
    else
        disp('tess_cortex_pial_low.mat does not exist' );
        brain = [];
    end
end

%% 2- Inflate the Outer and use it as a 4th face then Merge the surfaces
if cfg.numberOfLayer == 4
    % It will create a new srface by inflating the outer skull, the
    % inflated surface will be placed between the outer and inner skull,
    % and therefere divide the skull into 2 tissu, the most inned will be
    % the SCF and the outer will be the skull ... not too realistic... but
    % a fisrt version for he FEM
    depth = -cfg.skullThikness/1000;  % thickness of the new layer that should be the skull
    [NewVertices, NewFaces, ~] = bst_inflateORdeflate_surface (outer.Vertices,outer.Faces, depth);
    % Merge the surfaces
    [newnode,newelem]=mergemesh(head.Vertices,head.Faces,...
        NewVertices, NewFaces,...
        outer.Vertices,outer.Faces,...
        inner.Vertices,inner.Faces);
else
    % Merge the surfaces
    [newnode,newelem]=mergemesh(   head.Vertices,head.Faces,...
        outer.Vertices,outer.Faces,...
        inner.Vertices,inner.Faces);
end

if cfg.plotModel == 1;  hs = figure;
    plotmesh(newnode,newelem,'y>0');
    legend(flip(cfg.TissueLabels))
    title('Surface model (BEM)')
    if cfg.plotSource == 1
        if ~isempty(brain)
            hold on; plotmesh(brain.Vertices,brain.Faces,'facecolor',[0.5 0.5 0.5]);
            legend(flip([cfg.TissueLabels {'Source'}]))
            title('Surface model (BEM) & Source Space')
        end
    end
end

%% Find the seed point for each region
center_inner = mean(inner.Vertices);
% define seeds along the electrode axis
orig = center_inner; v0= [0 0 1];
[t,~,~,faceidx]=raytrace(orig,v0,newnode,newelem);
t=sort(t(faceidx)); t=(t(1:end-1)+t(2:end))*0.5; seedlen=length(t);
regions=repmat(orig(:)',seedlen,1)+repmat(v0(:)',seedlen,1).*repmat(t(:),1,3);
%% Generate the volume Mesh
factor_bst = 1.e-6; % scaling factor related to the units
% The order is important, the output label will be related to this order,
% which is related to the conductivity value.
clear node elem face;
[node,elem,face]=surf2mesh(  newnode,newelem,...
    min(newnode),max(newnode),...
    cfg.keepratio,cfg.maxvol*factor_bst,regions,[]);
elemID = unique(elem(:,5));
if length(elemID) ~= cfg.numberOfLayer
    error(['The generated head model has %d layers unstead of %d. \n'...
        'You need to check the mesh generation process']...
        , length(elemID),cfg.numberOfLayer);
end
% set the ID and plot the mesh is the option is activated
if cfg.plotModel == 1;  hv = figure; end
for ind = 1 : length(elemID)
    if cfg.plotModel == 1
        plotmesh(node,elem((elem(:,5)==elemID(ind)),:) ,'y>0','facecolor',faceColor(ind));
        hold on;
        grid on; grid minor;
    end% update the element ID to the original
    elem((elem(:,5)==elemID(ind)),5)  = (ind);
end
cfg.tissuID = unique( elem(:,5));
legend(cfg.TissueLabels)
title('Volume model (FEM)')


if cfg.plotSource == 1
    if ~isempty(brain)
        hold on; plotmesh(brain.Vertices,brain.Faces,'facecolor',[0.5 0.5 0.5]);
        legend([cfg.TissueLabels {'Source'}])
        title('Volume model (FEM) & Source Space')
    end
end
% update cfg. 
cfg.node = node;
cfg.elem = elem;
cfg.face = face;
%% Save the model
if cfg.saveModel == 1
    % Save the mesh
    bst_write_mesh_model(cfg)
end

%% Output of this function
%% Check the class of output parameters
if nargout == 1
    varargout{1} = cfg;
elseif nargout == 2
    varargout{1} = node;
    varargout{2} = elem;
end
end