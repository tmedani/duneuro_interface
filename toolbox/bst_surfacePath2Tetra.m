function [node,elem,tissus] = bst_surfacePath2Tetra(bstAnatomyPath,opts)
% function bst_surfacePath2Tetra(bstAnatomyPath,opts)% 
% This function is used to generate tetra mesh from the surface mesh
% it uses the 3 surface bst model, it generates a 4 th surface between the
% outer layer and the scalp 
% Input : 
% bstAnatomyPath : path to the anatomy folder and it shoud contain the bst
% surface files
% opts : matlab structue containing the folowwing information 
% opts.maxvol : the maximum volume of the terta, see iso2mesh options; 
% opts.keepratio : keep ration, value between 0 and 1, see iso2mesh options
% opts.thick_scf : scf thickenss, the layer on the top of the GM
% opts.thick_skull : skull thickness, the layer on the top of the SCF and bottom to the scalp  %mm
% output 
% [node,elem] liste of the nodes and elements
% example
% bstAnatomyPath = 'C:\matlab_toolbox\brainstorm\brainstorm3\defaults\anatomy\ICBM152';
% opts.maxvol = 0.1; 
% opts.keepratio = 0.8;
% opts.thick_scf = 3; %mm
% opts.thick_skull = 3; %mm
% [node,elem,tissus] = bst_surfacePath2Tetra(bstAnatomyPath,opts)

% Creation  August 28, 2019, Takfarinas MEDANI 
% Update : 
% October 10, 2019 : 


%% 1- Load the surfaces
% Here I use the default subject but it can be any of the surfaces
head  = load(fullfile(bstAnatomyPath,'tess_head.mat'));
inner  = load(fullfile(bstAnatomyPath,'tess_innerskull.mat'));
outer  = load(fullfile(bstAnatomyPath,'tess_outerskull.mat'));
brain  = load(fullfile(bstAnatomyPath,'tess_cortex_pial_low.mat'));

factor_bst = 1.e-6;

%% 2- Inflate the Outer and use it as a 4th face then Merge the surfaces
% depth = -3/1000;  % thickness of the new layer that should be the skucll                                               
% [NewVertices, NewFaces, NormalOnVertices] = bst_inflateORdeflate_surface (outer.Vertices,outer.Faces, depth)   ;                                              
% 
% [newnode,newelem]=mergemesh(head.Vertices,head.Faces,...
%                                                      NewVertices, NewFaces,...
%                                                      outer.Vertices,outer.Faces,...
%                                                      inner.Vertices,inner.Faces);
                                   
CSFdepth = -  opts.thick_scf /1000;  % thickness of the new layer that should be the skull     
[CSFVertices, CSFFaces, ~] = bst_inflateORdeflate_surface (inner.Vertices,inner.Faces, CSFdepth)   ;    

Skulldepth = - (opts.thick_skull + opts.thick_scf)/1000;  % thickness of the new layer that should be the skull     
[SkullVertices, SkullFaces, ~] = bst_inflateORdeflate_surface (inner.Vertices,inner.Faces, Skulldepth)   ;    

% Merge the surfaces
[newnode,newelem]=mergemesh(head.Vertices,head.Faces,...
                                                     SkullVertices, SkullFaces,...
                                                     CSFVertices, CSFFaces,...
                                                     inner.Vertices,inner.Faces);

figure;
plotmesh(newnode,newelem,'y>0');
hold on;
plotmesh(brain.Vertices,brain.Faces);
title('Merged surface')


% Find the seed point for each region
center_inner = mean(inner.Vertices);
%% define seeds along the electrode axis
orig = center_inner;
v0= [0 0 1];
[t,baryu,baryv,faceidx]=raytrace(orig,v0,newnode,newelem);
t=sort(t(faceidx));
t=(t(1:end-1)+t(2:end))*0.5;
seedlen=length(t);
seeds=repmat(orig(:)',seedlen,1)+repmat(v0(:)',seedlen,1).*repmat(t(:),1,3);

%% Generate the volume Mesh
regions = seeds;% [seedRegion1;seedRegion2;seedRegion3];
% The order is important, the output label will be related to this order,
% which is related to the conductivity value.
clear node elem face;
[node,elem,face]=surf2mesh(newnode,newelem,...
                                                min(newnode),max(newnode),...
                                                opts.keepratio,opts.maxvol *factor_bst,regions,[]);                                        
tissus = {'GM','CSF','Skull','Scalp'};
                                        
elemID = unique(elem(:,5));
figure;
col = ['w','b','g','r'];
elemID = unique(elem(:,5));
for ind = 1 : length(elemID)
plotmesh(node,elem((elem(:,5)==elemID(ind)),:) ,'y>0','facecolor',col(ind));
hold on;
grid on; grid minor;
% update the element ID to the original 
elem((elem(:,5)==elemID(ind)),5)  = (ind);
end
legend({'WM','CSF','Skull','Scalp'})
title('Volume mesh')

figure;
plotmesh(node,face ,'y>0')
title('Surface mesh')


end