function cfg = bst_standard_conductivity(cfg)

% define the std conductivity
% refers to standard_cond
% from inner to outer ... always.... 

if ~isfield(cfg,'isotropic'); cfg.isotropic = 1 ;end
if ~isfield(cfg,'useTensor'); cfg.useTensor = 0 ;end

elemID = unique(cfg.elem(:,5));
nblayers = length(unique(cfg.elem(:,5)));

if ~isfield(cfg,'conductivity');
    
    switch nblayers
        case 5
            tissu = {'WM','GM','CSF','Skull','Scalp'};
            conductivity = [ 0.126 0.275 1.654 0.010 0.465];
            if isotropic == 0
                cfg.conductivity_radial = cfg.conductivity ;
                cfg.conductivity_tangential = cfg.conductivity(1)/3.6 ;
            end
        case 4
            conductivity = [0.275 1.654 0.010 0.465];
            tissu = {'GM','CSF','Skull','Scalp'};
        case 3
            conductivity = [0.275 0.010 0.465];
            tissu = {'GM','Skull','Scalp'};
        case 2
            conductivity = [0.275 0.465];
            tissu = {'GM','Scalp'};
        case 1
            conductivity = [ 0.465];
            tissu = {'Scalp'};
        otherwise
            error('error on your model')
    end
    cfg.conductivity = conductivity;
    
end


if cfg.isotropic == 1
    cfg.conductivity_radial = cfg.conductivity ;
    cfg.conductivity_tangential = cfg.conductivity ;
    if cfg.useTensor == 1
        cfg.conductivity_radial = cfg.conductivity ;
        cfg.conductivity_tangential = cfg.conductivity ;
    end
else % use ration for the wm lookat Marios pipline
    % cond_ratio       = 3.6;   % conductivity ratio according to Akhtari et al., 2002
    cfg.conductivity_radial = cfg.conductivity ;
    cfg.conductivity_tangential = cfg.conductivity ;
end

