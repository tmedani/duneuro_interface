function [dip_pos, dip_ori] = bst_generate_source_space(cortex_surface,opts)
% Generate the source space from the grey matter
% [dip_pos, dip_ori] = bst_generate_dipole(cortex_surface,opts)
% Inputs :
% cortex_surface : the cortex surface, either the a structure with the
% Vertices and Faces or the path to the matlab with bst surface file similar to
% 'tess_cortex_pial.mat'
% The options opts is a structure with these fields
% opts.decimate_cortex : decimate the cortex either 1 for yes or 0 the
% opts.keepratio = 0.01; used only if  opts.decimate_cortex = 1;
% whole cortex
% opts.under_node_or_face : define the dipole position under the nodes or
% the faces. 1 for sources under the nodes or 0 for dipoles under the faces
% opts.source_depth : the depth of the source space from the cortex outer
% surface. The value that user enter is in mm and then converted to meter
% in this function
% Output :
% dip_pos : x, y ,z positon of the sources
% dip_ori : x, y, z, : the 3D componemt defining a normal unit vector from each
% dipole positon
% 1 - decimate the cortex
% 2 - source under nodes or source under surfaces// under the node is
% recommanded
% 3 - profondeur des sources par rapport au cortex


skin_surface_clr         = [255 213 119]/255;
outer_skull_surface_clr  = [140  85  85]/255;
inner_skull_surface_clr  = [202 50 150]/255;
cortex_clr = [227 223 229]/255;
couleur=[skin_surface_clr;outer_skull_surface_clr;inner_skull_surface_clr;cortex_clr];
%% get the option
if ischar(cortex_surface)
    brain = load(cortex_surface);
    nodes_br = brain.Vertices;
    brain_surface_facets = brain.Faces;
    clear brain
elseif isstruct(cortex_surface)
    nodes_br = cortex_surface.Vertices;
    brain_surface_facets = cortex_surface.Faces;
    clear cortex_surface
else
    error(['The cortex_surface (arg1) is not correct'])
end

% opts.decimate_cortex = 1; % reduce the number of source
% opts.under_node_or_face = 1; % 1 for node and 0 for face
% opts.source_depth = 0.004; % metre
%     opts.keepratio = 0.01;

figure_title = ['Source'];
if opts.decimate_cortex == 1
    % ratio of the node that should be kept
    %     opts.keepratio = 0.01;
    figure_title = [figure_title ' decimated at ' num2str(100*opts.keepratio) ];
end
figure_title = [figure_title ' at depth ' num2str(opts.source_depth*1000) 'mm' ];

%% Start here
if opts.decimate_cortex == 1    
    [sources,faces_sources]=meshresample(nodes_br,brain_surface_facets,opts.keepratio );
    nodes_br = sources;
    brain_surface_facets = faces_sources;
end

%I: Reorientation des surfaces
[nodes_br,brain_surface_facets]=surfreorient(nodes_br,brain_surface_facets);

% II : Compute the normal at each centroide of face and/or the normal at each node
TR = triangulation(brain_surface_facets,nodes_br(:,1),nodes_br(:,2),nodes_br(:,3));
if opts.under_node_or_face == 1 % 1 for node and 0 for facette
    nrm_sur_nodes = vertexNormal(TR);
    % I- Trouver les composante spherique de chaque normale à la surface:
    [azimuth,elevation,r_norm] = cart2sph(nrm_sur_nodes(:,1),nrm_sur_nodes(:,2),nrm_sur_nodes(:,3));
    figure_title = [ figure_title ' defined on '  num2str(length(nodes_br)) ' nodes' ];
    %% II - Choisir la profondeur de la postion de l'espace des sources dans la couche du cortex :
    profondeur_sources=opts.source_depth/1000; % en mm
    
    %% III- Trouver les composantes dans les trois directions à partir du point centroide de chaque facette:
    profondeur_x = profondeur_sources .* cos(elevation) .* cos(azimuth);
    profondeur_y = profondeur_sources .* cos(elevation) .* sin(azimuth);
    profondeur_z = profondeur_sources .* sin(elevation);
    % verif=sqrt(profondeur_x.^2+profondeur_y.^2+profondeur_z.^2);
    %% IV- Appliquer cette profondeur dans chque direction à partir du centroide de chaque feacette:
    pos_source_x=nodes_br(:,1)-profondeur_x;
    pos_source_y=nodes_br(:,2)-profondeur_y;
    pos_source_z=nodes_br(:,3)-profondeur_z;
else % norm on facette
    nrm_sur_facette = faceNormal(TR);%size(FN);
    brain_face_centroide=meshcentroid(nodes_br,brain_surface_facets);
    [azimuth,elevation,r_norm] = cart2sph(brain_face_centroide(:,1),brain_face_centroide(:,2),brain_face_centroide(:,3));
    figure_title = [ figure_title ' defined on '  num2str(length(brain_surface_facets)) ' faces' ];
    %% II - Choisir la profondeur de la postion de l'espace des sources dans la couche du cortex :
    profondeur_sources=opts.source_depth/1000; % en mm
    
    %% III- Trouver les composantes dans les trois directions à partir du point centroide de chaque facette:
    profondeur_x = profondeur_sources .* cos(elevation) .* cos(azimuth);
    profondeur_y = profondeur_sources .* cos(elevation) .* sin(azimuth);
    profondeur_z = profondeur_sources .* sin(elevation);
    % verif=sqrt(profondeur_x.^2+profondeur_y.^2+profondeur_z.^2);
    %% IV- Appliquer cette profondeur dans chque direction à partir du centroide de chaque feacette:
    pos_source_x=brain_face_centroide(:,1) - profondeur_x;
    pos_source_y=brain_face_centroide(:,2) - profondeur_y;
    pos_source_z=brain_face_centroide(:,3) - profondeur_z;
end

%% V- Espace de source avec une profondeur définit par la variable : profondeur_sources
dip_pos=[pos_source_x pos_source_y pos_source_z];
[ori_source_x, ori_source_y, ori_source_z] =  sph2cart(azimuth,elevation,r_norm);
dip_ori = [ori_source_x, ori_source_y, ori_source_z] ;

%figure;plotmesh(source_space,brain_surface_facets,'facecolor',cortex_clr);

%% VI - Verification que toutes les sources sont bien dans la couche du cortex:

figure('color',[1 1 1]);
plotmesh(nodes_br,brain_surface_facets,'FaceColor',cortex_clr,'facealpha',0.2,'edgecolor','none');
%% Ajouter les vecteurs
viz_data = 100:300;
if opts.under_node_or_face == 1 % 1 for node and 0 for facette
    hold on; quiver3(dip_pos(viz_data,1),dip_pos(viz_data,2),dip_pos(viz_data,3),...
        nrm_sur_nodes(viz_data,1),nrm_sur_nodes(viz_data,2),nrm_sur_nodes(viz_data,3),0.1,'color','r');
    hold on; plotmesh(nodes_br(viz_data,:),'k.')
    hold on;plotmesh(dip_pos(viz_data,:),'bo');
else
    hold on; quiver3(dip_pos(viz_data,1),dip_pos(viz_data,2),dip_pos(viz_data,3),...
        nrm_sur_facette(viz_data,1),nrm_sur_facette(viz_data,2),nrm_sur_facette(viz_data,3),0.1,'color','r');
    hold on; plotmesh(brain_face_centroide(viz_data,:),'k.')
    hold on;plotmesh(dip_pos(viz_data,:),'bo');
end
hold on
plotmesh(nodes_br, brain_surface_facets, 'facecolor','g','facealpha',0.3)
title(figure_title)
% legend('nodes','sources')

%% Save the source space
Comment = ['cortex_' num2str(length(dip_pos))];
Vertices = dip_pos;
Faces = brain_surface_facets;
VertConn = [];
VertNormals = [];
Curvature = [];
SulciMap = [];
Atlas = [];
iAtlas = 1;
tess2mri_interp = [];
Reg = [];
History = [];
save('tess_cortex.mat','Comment','Vertices','Faces','VertConn','VertNormals','Curvature','SulciMap','Atlas','iAtlas','tess2mri_interp','Reg','History');

end