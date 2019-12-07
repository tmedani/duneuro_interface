clear all; close all; %#ok<CLALL>
%   SYNTAX 
%   mesh_expansion_shrinkage.m
%   DESCRIPTION 
%   This script performs mesh extension/shrinkage in the direction of the
%   normal vector. May be applied to selected nodes only
%
%   SNM 2016-2019

[FileName, PathName] = uigetfile('*.mat','Select the mesh file');
load(FileName); %   load P, t, normals

P0 = P; t0 = t; normals0 = normals;
%  normal direction in mm (positive for extension, negative for shrinkage)
alpha = 1.0; 
%   Find triangles attached to every vertex (cell array)
si = meshconnvt(t);
%   Move selected nodes in the direction of the inner/outer normal vector
%   taking into account the local topology (important)
index = 1:length(P);
Ptemp = P(index, :);
for m = 1:length(index)
    n = index(m);
    averagenormal = sum(normals(si{n}, :), 1)/length(si{n});
    norm          = sqrt(dot(averagenormal, averagenormal));
    tangent       = norm;  
    Ptemp(m, :) = Ptemp(m, :) + alpha*(averagenormal/norm)/tangent^1.0;
end 
P(index, :) = Ptemp;    

if alpha>0
    %   View the original mesh
    patch('vertices', P0, 'faces', t0, 'EdgeColor', 'k', 'FaceAlpha', 0.5,'FaceColor', 'y');
    %   View the deformed mesh
    patch('vertices', P, 'faces', t, 'EdgeColor', 'k', 'FaceAlpha', 0.5,'FaceColor', 'c');
else
    %   View the original mesh
    patch('vertices', P0, 'faces', t0, 'EdgeColor', 'k', 'FaceAlpha', 0.5,'FaceColor', 'c');
    %   View the deformed mesh
    patch('vertices', P, 'faces', t, 'EdgeColor', 'k', 'FaceAlpha', 0.5,'FaceColor', 'y');
end

axis 'equal';  axis 'tight'; grid on
xlabel('x, mm'); ylabel('y, mm'); zlabel('z, mm'); view(90, 0)

%   Recompute/re-check normals vectors based on the previous values
N           = size(t, 1);
for m = 1:N
    Vertexes        = P(t(m, 1:3)', :)';
    r1              = Vertexes(:, 1);
    r2              = Vertexes(:, 2);
    r3              = Vertexes(:, 3);
    tempv           = cross(r2-r1, r3-r1);  %   definition (*)
    temps           = sqrt(tempv(1)^2 + tempv(2)^2 + tempv(3)^2);
    normals(m, :)   = tempv'/temps;
    if sum(normals(m, :).*normals0(m, :))<0;    %   rearrange vertices to have exactly the outer normal
        t(m, 2:3)       = t(m, 3:-1:2);               %   by definition (*)
        normals(m, :)   = - normals(m, :);
    end     
end   
%    Save the new shell
save(strcat(FileName(1:end-4),'_mod'), 'P', 't', 'normals');

function [si] = meshconnvt(t)
%   SYNTAX 
%   [si] = meshconnvt(t)
%   DESCRIPTION 
%   This function returns triangles attached to every vertex (a cell array si) 
%
%   Low-Frequency Electromagnetic Modeling for Electrical and Biological
%   Systems Using MATLAB, Sergey N. Makarov, Gregory M. Noetscher, and Ara
%   Nazarian, Wiley, New York, 2015, 1st ed.

   N  = max(max(t));
    si = cell(N, 1);
    for m = 1:N
        temp  = (t(:,1)==m)|(t(:,2)==m)|(t(:,3)==m);
        si{m} = find(temp>0);
    end 
end






