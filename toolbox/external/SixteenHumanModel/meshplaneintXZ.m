
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