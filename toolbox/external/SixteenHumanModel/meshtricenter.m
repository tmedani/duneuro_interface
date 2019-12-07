function C = meshtricenter(P, t) 
%   SYNTAX
%   C = meshtricenter(P, t) 
%   DESCRIPTION
%   This function returns triangle centers (a Nx3 array)
%
%   Copyright SNM 2012-2018

    C   = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :));
end
   
    
