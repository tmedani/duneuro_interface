function [node, face, cfg]  = bst_mesh_sphere_volume(cfg)

% cfg.node;
% cfg.face;
% cfg.maxvol;
% cfg.keepratio;
% cfg.plotMesh;


if ~isfield(cfg,'factor_bst') ; cfg.factor_bst =1.e-6; end
maxvol = cfg.maxvol;%0.001;
if ~isfield(cfg,'keepratio'); cfg.keepratio = 1; end% cfg.keepratio; %0.8;
keepratio = cfg.keepratio;
%% Generate volume mesh
% Find the seed point for each region
newnode = cfg.node;
newelem = cfg.face;
center_inner = cfg.sphereCenter;

%% define seeds along the electrode axis
orig = center_inner;
v0= [0 0 1];
[t,~,~,faceidx]=raytrace(orig,v0,newnode,newelem);
t=sort(t(faceidx));
t=(t(1:end-1)+t(2:end))*0.5;
seedlen=length(t);
seeds=repmat(orig(:)',seedlen,1)+repmat(v0(:)',seedlen,1).*repmat(t(:),1,3);
% Generate volume mesh

regions = seeds;% [seedRegion1;seedRegion2;seedRegion3];
% The order is important, the output label will be related to this order,
% which is related to the conductivity value.
clear node elem face;
[node,elem,face]=surf2mesh(newnode,newelem,...
    min(newnode),max(newnode),...
    keepratio,maxvol*cfg.factor_bst,regions,[]);


defineTissuColor

nblayers = length(unique(elem(:,5)));
switch nblayers
    case 5
        tissuColor = tissuColor5Layer;
        tissu = {'WM','GM','CSF','Skull','Scalp'};
    case 4
        tissuColor = tissuColor4Layer;
        tissu = {'GM','CSF','Skull','Scalp'};        
    case 3
        tissuColor = tissuColor3Layer;
        tissu = {'GM','Skull','Scalp'};        
    case 2
        tissuColor = tissuColor2Layer;
        tissu = {'GM','Scalp'};        
    case 1
        tissuColor = tissuColor1Layer;
        tissu = {'Scalp'};        
    otherwise
        error('error on your meshing')
end





elemID = (unique(elem(:,5)));
figure;
for ind = 1 : length(elemID)
   plotmesh(node,elem((elem(:,5)==elemID(ind)),:) ,'y>0','facecolor',tissuColor(ind,:));
    hold on;
    %grid on; grid minor;
    % update the element ID to the original
    elem((elem(:,5)==elemID(ind)),5)  = (ind);
end
legend(tissu)

cfg.node = node;
cfg.elem = elem;
cfg.tissuColor = tissuColor;
cfg.tissu = tissu;
cfg.tissuLabel = elemID;

end
