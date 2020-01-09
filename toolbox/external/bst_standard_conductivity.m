function cfg = bst_standard_conductivity(cfg)

% use :
%cfg = bst_standard_conductivity(cfg) : get the valu of the conductivities
%                                                             according to the number of layers.
% define the std conductivity
% refers to standard_cond
% from inner to outer ... always....



if ~isfield(cfg,'isotropic'); cfg.isotropic = 1 ;end
if ~isfield(cfg,'useTensor'); cfg.useTensor = 0 ;end

elemID = unique(cfg.elem(:,5));
nblayers = length(unique(cfg.elem(:,5)));

simNibsValue = 0; % use value published by SimNibs team, Axel
simBioValue = 1; % use value published by SimBio team, Carsten and Johannes : A guidline for head volume ....
if ~isfield(cfg,'conductivity')
    if simNibsValue
        switch nblayers
            case 6
                tissu = {'WM','GM','CSF','Skull Spongia','Skull Compacta','Scalp'};% simnibs paper & soft
                conductivity = [ 0.126 0.275 1.654 0.010 0.465];% simnibs paper & soft
                if isotropic == 0
                    cfg.conductivity_radial = cfg.conductivity ;
                    cfg.conductivity_tangential = cfg.conductivity(1)/3.6 ;
                end
            case 5
                tissu = {'WM','GM','CSF','Skull','Scalp'};% simnibs paper & soft
                conductivity = [ 0.126 0.275 1.654 0.010 0.465];% simnibs paper & soft
                if isotropic == 0
                    cfg.conductivity_radial = cfg.conductivity ;
                    cfg.conductivity_tangential = cfg.conductivity(1)/3.6 ;
                end
            case 4
                conductivity = [0.275 1.654 0.010 0.465];% simnibs paper & soft
                tissu = {'GM','CSF','Skull','Scalp'};% simnibs paper & soft
            case 3
                conductivity = [0.275 0.010 0.465];% simnibs paper & soft
                tissu = {'GM','Skull','Scalp'};% simnibs paper & soft
            case 2
                conductivity = [0.275 0.465];% simnibs paper & soft
                tissu = {'GM','Scalp'};% simnibs paper & soft
            case 1
                conductivity = [ 0.465];% simnibs paper & soft
                tissu = {'Scalp'};% simnibs paper & soft
            otherwise
                error('error on your model')
        end
    end
    if simBioValue
        switch nblayers
            case 6
                tissu = {'WM','GM','CSF','Skull Spongia','Skull Compacta','Scalp'}; %SimBio team
                conductivity = [ 0.14 0.33 1.79 0.025 0.008 0.43];
                if isotropic == 0
                    cfg.conductivity_radial = cfg.conductivity ;
                    cfg.conductivity_tangential = cfg.conductivity(1)/3.6 ;
                end
            case 5
                tissu = {'WM','GM','CSF','Skull','Scalp'};
                conductivity = [ 0.14 0.33 1.79  0.01 0.43];
                if isotropic == 0
                    cfg.conductivity_radial = cfg.conductivity ;
                    cfg.conductivity_tangential = cfg.conductivity(1)/3.6 ;
                end
            case 4
                conductivity = [ 0.33 1.79 0.01 0.43];
                tissu = {'GM','CSF','Skull','Scalp'};
            case 3
                conductivity = [0.33 0.01 0.43];
                tissu = {'GM','Skull','Scalp'};
            case 2
                conductivity = [0.33 0.43];
                tissu = {'GM','Scalp'};
            case 1
                conductivity = [0.43];
                tissu = {'Scalp'};
            otherwise
                error('error on your model')
        end
    end
cfg.conductivity = conductivity;
cfg.TissuLabels = tissu;
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

end
