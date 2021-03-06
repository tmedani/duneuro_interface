function [NewVertices, NewFaces, NormalOnVertices] = bst_inflateORdeflate_surface (Vertices, Faces, depth)
% bst_inflateORdeflate_surface (Vertices, Faces, depth) : Infalte or
% deflate a surface mesh on the normal direction (outward==> infalte, inward ==> deflate)
%
% USAGE:     [NewVertices, NewFaces, NormalOnVertices] = bst_inflateORdeflate_surface (Vertices, Faces, depth)
%       

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2019 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Takfarinas Medani, Created Septembre 2019,
 %                                              Adapted to Brainstorm, December 2019,    

%% I: Reorientation des surfaces
[Vertices,Faces]=surfreorient(Vertices,Faces);

%% II : Compute the normal at each centroide of face and/or the normal at each node
TR = triangulation(Faces,Vertices(:,1),Vertices(:,2),Vertices(:,3));
nrm_sur_nodes = vertexNormal(TR);
% I- Trouver les composante spherique de chaque normale � la surface:
[azimuth,elevation,r_norm] = cart2sph(nrm_sur_nodes(:,1),nrm_sur_nodes(:,2),nrm_sur_nodes(:,3));
% figure_title = [ figure_title ' defined on '  num2str(length(Vertices)) ' nodes' ];
%% II - Choisir la profondeur de la postion de l'espace des sources dans la couche du cortex :
profondeur_sources=depth; % en mm
% This function can either inflate or deflate a closed surface by a distance depth
% distance of the inflate<0 or deflate >0 

%% III- Trouver les composantes dans les trois directions � partir du point centroide de chaque facette:
profondeur_x = profondeur_sources .* cos(elevation) .* cos(azimuth);
profondeur_y = profondeur_sources .* cos(elevation) .* sin(azimuth);
profondeur_z = profondeur_sources .* sin(elevation);
% verif=sqrt(profondeur_x.^2+profondeur_y.^2+profondeur_z.^2);

%% IV- Appliquer cette profondeur dans chque direction � partir du centroide de chaque feacette:
pos_source_x=Vertices(:,1)-profondeur_x;
pos_source_y=Vertices(:,2)-profondeur_y;
pos_source_z=Vertices(:,3)-profondeur_z;

%% V- Espace de source avec une profondeur d�finit par la variable : profondeur_sources
NewVertices=[pos_source_x pos_source_y pos_source_z];
[ori_source_x, ori_source_y, ori_source_z] =  sph2cart(azimuth,elevation,r_norm);
NormalOnVertices = [ori_source_x, ori_source_y, ori_source_z] ;
NewFaces = Faces;

% The outputs are the same nodes shifted in the normal direction inside (deflate) or
% outside (inflate) depending on the signe of depth. It computes also the
% normal to each vertices.
% Created by Takfarinas MEDANI, September 2019;
end
