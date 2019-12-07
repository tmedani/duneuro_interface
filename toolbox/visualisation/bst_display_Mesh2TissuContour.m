function cfg = bst_display_Mesh2TissuContour(cfg,opts)

%  cfg = bst_display_Mesh2TissuContour(cfg,opts);
%   This script computes tissue mesh intersections with
%   the XY plane (transverse plane) located at Z=0 or elsewhere, ==>
%   the XZ plane  (coronal plane) located at Y=0 or elsewhere
%   the YZ plane  (saggital plane) located at X=0 or elsewhere
%   opts.crossPlanName = 'XY'
%   opts.crossPlanName = 'XZ'
%   opts.crossPlanName = 'YZ'

%   Copyright SNM 2012-2018

% Takfarinas MEDANI December 2019;

% opts.crossPlanName = 'XY'; % string:
% opts.crossPlanValue = 0.01;
%  cfg = bst_display_Mesh2TissuContour(cfg,opts);

% default opts transversal
if ~isfield(opts,'crossPlanName'); opts.crossPlanName = 'transverse'; end
if ~isfield(opts,'crossPlanValue'); opts.crossPlanValue = mean(cfg.node(:,3)); end

% check the input
switch 1
    case strcmpi((opts.crossPlanName),'xy') || strcmpi((opts.crossPlanName),'yx')...
            || strcmpi((opts.crossPlanName),'transverse') || strcmpi((opts.crossPlanName),'axial')
        opts.crossPlanName = 'transverse';
        opts.crossPlanValue;% 0.01;   % here is the plane position
        cuttingAxe = 'z'; coor_index = [1,2];
%         mesh_plane_expression = '[Pi, ti, polymask, flag] = meshplaneintXY(P, t, edges, opts.crossPlanValue);';
    case strcmpi((opts.crossPlanName),'xz') ||  strcmpi((opts.crossPlanName),'zx') || ...
            strcmpi((opts.crossPlanName),'coronal')
        opts.crossPlanName = 'coronal';
        opts.crossPlanValue;% 0.01;   % here is the plane position
        cuttingAxe = 'y'; coor_index = [1,3];
%         mesh_plane_expression = '[Pi, ti, polymask, flag] = meshplaneintXZ(P, t, edges, opts.crossPlanValue);';
    case strcmpi((opts.crossPlanName),'yz') || strcmpi((opts.crossPlanName),'zy') ...
            || strcmpi((opts.crossPlanName),'saggital')
        opts.crossPlanName = 'saggital';
        opts.crossPlanValue;% 0.01;   % here is the plane position
        cuttingAxe = 'x'; coor_index = [2,3];
%         mesh_plane_expression = '[Pi, ti, polymask, flag] = meshplaneintYZ(P, t, edges, opts.crossPlanValue);';
    otherwise
        error('The %s is not supported',opts.crossPlanName)
end

if ~isfield(cfg,'bemFace')
    % surface extraction is needed
    cfg = bst_extract_surface_from_volume(cfg);
end

%   Create coordinates of intersection contours and intersection edges
tissues = length(cfg.bemTissu);
Pof = cell(tissues, 1);   %   intersection nodes for a tissue
Eof = cell(tissues, 1);   %   edges formed by intersection nodes for a tissue
Tof = cell(tissues, 1);   %   intersected triangles
count = [];     % number of every tissue present in the slice

unitConversion =1; 
for m = 1:tissues
    [P, t] = fixmesh( cfg.bemNode{m}, cfg.bemFace{m});
    P = unitConversion*P; % the model has to be in meters!
    edges = meshconnee(t);
%     evalc(mesh_plane_expression);
    if cuttingAxe == 'z'; [Pi, ti, polymask, flag] = meshplaneintXY(P, t, edges, opts.crossPlanValue);end
    if cuttingAxe == 'y';[Pi, ti, polymask, flag] = meshplaneintXZ(P, t, edges, opts.crossPlanValue);end
    if cuttingAxe == 'x'; [Pi, ti, polymask, flag] = meshplaneintYZ(P, t, edges, opts.crossPlanValue);end
    if flag % intersection found
        count               = [count m];
        inslice             = length(count); %  total number of tissues present in the slice
         Pof{inslice}      = Pi;           %   intersection nodes
         Eof{inslice}      = polymask;     %   edges formed by intersection nodes
         Tof{inslice}      = ti;           %   edges formed by intersection nodes
    end
end

% Display the result
%figure;
plot_mesh_contour(count,inslice,Pof,Eof,coor_index,cuttingAxe,cfg,opts)

end

function plot_mesh_contour(count,inslice,Pof,Eof,coor_index,cuttingAxe,cfg,opts)
%   Assign contour colors
color = prism(inslice);
hold on;
for m = 1:inslice
   for n = 1:size(Eof{m}, 1)
       i1 = Eof{m}(n, 1);
       i2 = Eof{m}(n, 2);
       line(Pof{m}([i1 i2], coor_index(1)), Pof{m}([i1 i2], coor_index(2)), 'Color', color(m, :), 'LineWidth', 2);
   end
end
%   Insert colorbar with tissue names
mytickmap = cell(inslice, 1);
for m = 1:inslice
    mytickmap{m} = cfg.bemTissu{count(m)};
end
ticks      = linspace(0.5/inslice, 1-0.5/inslice, inslice);
colormap(color) %// apply colormap
colorbar %// show color bar
l = colorbar('Ticks', ticks, 'TickLabels', mytickmap);
set(l, 'TickLabelInterpreter', 'none')
title(strcat(upper(opts.crossPlanName(1)), opts.crossPlanName(2:end) ...
    ,' cross-section at',' ', cuttingAxe, ' ','=',' ', num2str( opts.crossPlanValue)));
if cuttingAxe == 'z'; xlabel('x'); ylabel('y');end
if cuttingAxe == 'y'; xlabel('x'); ylabel('z');end
if cuttingAxe == 'x'; xlabel('x'); ylabel('z');end

axis 'equal';  axis 'tight';
% axis([xmin xmax ymin ymax]);
set(gcf,'Color','White');
end

%% functions
function [Pi, ti, polymask, flag] = meshplaneintXY(P, t, edges, Z) 
%   This function implements the mesh intersection algorithm for the XY plane 
%   Output:
%   flag = 0 -> no intersection
%   Pi - intersection nodes
%   polymask - edges formed by intersection nodes
%   ti - indexes into intersected triangles
%
%   Copyright SNM 2017-2018

%   Make sure there are no nodes straight on the plane!
    while 1
        index1  = P(edges(:, 1), 2)==Z; 
        index2  = P(edges(:, 2), 2)==Z; 
        indexU  = find(index1|index2);
        if ~isempty(indexU)
            Z = Z*(1+1e-12);
        else
            break;
        end 
    end    
    
    p = [0 0 Z];
    n = [0 0 1];
    flag = 1;
    Pi = [];
    ti = [];
    polymask = [];
    
    %   Find all edges (edgesI) intersecting the given plane
    index1  = P(edges(:, 1), 3)>Z; 
    index2  = P(edges(:, 2), 3)>Z;
    index3  = P(edges(:, 1), 3)<Z; 
    index4  = P(edges(:, 2), 3)<Z;
    indexU  = index1&index2;
    indexL  = index3&index4;
    indexI  = (~indexU)&(~indexL);
    edgesI  = edges(indexI, :);     %   sorted
    E       = size(edgesI, 1);
    if E==0
        flag = 0;
        return;
    end    
    %   Find all intersection points (Pi)
    N   = repmat(n, [E 1]);                         % repmat plane normal
    Pn  = repmat(p, [E 1]);                         % repmat plane center
    V2      = P(edgesI(:, 2), :);
    V1      = P(edgesI(:, 1), :);
    dot1    = dot(N, (V2 - Pn), 2);
    dot2    = dot(N, (V2 - V1), 2);
    dot3    = dot1./dot2; 
    Pi      = V2 - (V2-V1).*repmat(dot3, [1 3]);
    %  Establish pairs of interconnected edges (pairs of interconnected edge nodes)
    AttTriangles   = meshconnet(t, edgesI, 'manifold');    
    AttTrianglesU  = unique([AttTriangles(:, 1)' AttTriangles(:, 2)'])';
    polymask       = zeros(E, 2);
    for m = 1:E
        temp1 = find(AttTriangles(:, 1)==AttTrianglesU(m));
        temp2 = find(AttTriangles(:, 2)==AttTrianglesU(m));
        polymask(m, :)= [temp1 temp2];
    end
    ti = AttTrianglesU;
end

function [Pi, ti, polymask, flag] = meshplaneintXZ(P, t, edges, Y) 
%   This function implements the mesh intersection algorithm for the XZ plane 
%   Output:
%   flag = 0 -> no intersection
%   Pi - intersection nodes
%   polymask - edges formed by intersection nodes
%
%   Copyright SNM 2017-2018

%   Make sure there are no nodes straight on the plane!
    while 1
        index1  = P(edges(:, 1), 2)==Y; 
        index2  = P(edges(:, 2), 2)==Y; 
        indexU  = find(index1|index2);
        if ~isempty(indexU)
            Y = Y*(1+1e-12);
        else
            break;
        end 
    end    
    
    p = [0 Y 0];
    n = [0 1 0];
    flag = 1;
    Pi = [];
    ti = [];
    polymask = [];
    
    %   Find all edges (edgesI) intersecting the given plane
    index1  = P(edges(:, 1), 2)>Y; 
    index2  = P(edges(:, 2), 2)>Y;
    index3  = P(edges(:, 1), 2)<Y; 
    index4  = P(edges(:, 2), 2)<Y;
    indexU  = index1&index2;
    indexL  = index3&index4;
    indexI  = (~indexU)&(~indexL);
    edgesI  = edges(indexI, :);     %   sorted
    E       = size(edgesI, 1);
    if E==0
        flag = 0;
        return;
    end    
    %   Find all intersection points (Pi)
    N   = repmat(n, [E 1]);                         % repmat plane normal
    Pn  = repmat(p, [E 1]);                         % repmat plane center
    V2      = P(edgesI(:, 2), :);
    V1      = P(edgesI(:, 1), :);
    dot1    = dot(N, (V2 - Pn), 2);
    dot2    = dot(N, (V2 - V1), 2);
    dot3    = dot1./dot2; 
    Pi      = V2 - (V2-V1).*repmat(dot3, [1 3]);
    %  Establish pairs of interconnected edges (pairs of interconnected edge nodes)
    AttTriangles   = meshconnet(t, edgesI, 'manifold');    
    AttTrianglesU  = unique([AttTriangles(:, 1)' AttTriangles(:, 2)'])';
    polymask       = zeros(E, 2);
    for m = 1:E
        temp1 = find(AttTriangles(:, 1)==AttTrianglesU(m));
        temp2 = find(AttTriangles(:, 2)==AttTrianglesU(m));
        polymask(m, :)= [temp1 temp2];
    end
    ti = AttTrianglesU;
end

function [Pi, ti, polymask, flag] = meshplaneintYZ(P, t, edges, X) 
%   This function implements the mesh intersection algorithm for the YZ plane 
%   Output:
%   flag = 0 -> no intersection
%   Pi - intersection nodes
%   polymask - edges formed by intersection nodes
%
%   Copyright SNM 2017-2018

%   Make sure there are no nodes straight on the plane!
    while 1
        index1  = P(edges(:, 1), 2)==X; 
        index2  = P(edges(:, 2), 2)==X; 
        indexU  = find(index1|index2);
        if ~isempty(indexU)
            X = X*(1+1e-12);
        else
            break;
        end 
    end    
    
    p = [X 0 0];
    n = [1 0 0];
    flag = 1;
    Pi = [];
    ti = [];
    polymask = [];
    
    %   Find all edges (edgesI) intersecting the given plane
    index1  = P(edges(:, 1), 1)>X; 
    index2  = P(edges(:, 2), 1)>X;
    index3  = P(edges(:, 1), 1)<X; 
    index4  = P(edges(:, 2), 1)<X;
    indexU  = index1&index2;
    indexL  = index3&index4;
    indexI  = (~indexU)&(~indexL);
    edgesI  = edges(indexI, :);     %   sorted
    E       = size(edgesI, 1);
    if E==0
        flag = 0;
        return;
    end    
    %   Find all intersection points (Pi)
    N   = repmat(n, [E 1]);                         % repmat plane normal
    Pn  = repmat(p, [E 1]);                         % repmat plane center
    V2      = P(edgesI(:, 2), :);
    V1      = P(edgesI(:, 1), :);
    dot1    = dot(N, (V2 - Pn), 2);
    dot2    = dot(N, (V2 - V1), 2);
    dot3    = dot1./dot2; 
    Pi      = V2 - (V2-V1).*repmat(dot3, [1 3]);
    %  Establish pairs of interconnected edges (pairs of edge nodes)
    AttTriangles   = meshconnet(t, edgesI, 'manifold');    
    AttTrianglesU  = unique([AttTriangles(:, 1)' AttTriangles(:, 2)'])';
    polymask       = zeros(E, 2);
    for m = 1:E
        temp1 = find(AttTriangles(:, 1)==AttTrianglesU(m));
        temp2 = find(AttTriangles(:, 2)==AttTrianglesU(m));
        polymask(m, :)= [temp1 temp2];
    end
    ti = AttTrianglesU;
end
