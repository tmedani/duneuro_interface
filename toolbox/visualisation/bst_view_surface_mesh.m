function cfg = bst_view_surface_mesh(varargin)

% opts.surfaceIndex = 1; index of the surface
% cfg = bst_view_surface_mesh(cfg,opts)
% or
%  bst_view_surface_mesh(node,face)


screenSize = get(0, 'ScreenSize');
left = screenSize(3)/2; bottom = screenSize(4)/4; width =  1*screenSize(3)/2; height =  3*screenSize(4)/4;
figure('OuterPosition', [left bottom width height]);

if isstruct(varargin{1})
    cfg = varargin{1};
    opts = varargin{2};
    % need to extract the surcaes
    if ~isfield(cfg,'bemFace')
        % surface extraction is needed
        cfg = bst_extract_surface_from_volume(cfg);
    end
    
    p = patch('vertices', cfg.bemNode{opts.surfaceIndex}, 'faces', cfg.bemFace{opts.surfaceIndex});
end

if ~isstruct(varargin{1})
    node = varargin{1};
    face = varargin{2};
    p = patch('vertices', node, 'faces', face);
    
end
rotate3d on

p.FaceColor = [1 0.75 0.65];
p.EdgeColor = 'none';
p.FaceAlpha = 1.0;
daspect([1 1 1])
camlight; lighting flat;
xlabel('x, mm'); ylabel('y, mm'); zlabel('z, mm');
set(gcf,'Color','White');

end