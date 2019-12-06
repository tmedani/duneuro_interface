function cfg = bst_define_conductivity_tensor(cfg)
% define the conductivity tensor either for the realistic or spherical head
% model.

% Use the tensor formulation in the case of isotrpic ==> validation model
if ~isfield(cfg,'useTensor') ; cfg.useTensor = 0 ; end

disp('If you want to use the tensor model for an isotrpic model, please set cfg.useTensor to 1')

if cfg.isotropic ==1
    if cfg.sphereModel ==1 % spherical head model
        if cfg.useTensor == 1
            % Define the conductivity tensor  :
            cfg = bst_generate_tensor_on_elem(cfg);
            %% Check the size of the tensor :
            if ~(length(cfg.conductivity_tensor) == length(cfg.elem))
                error(' The size of the tensor is different to the size of elem')
            end
        else
            cfg.conductivity = cfg.conductivity;
        end
    else                               % realistic head model
        % TODO : read the tensror from the DTI output or from the template
        % TODO : display tensor as elipsoid
    end
else % Anistropic model
    cfg.useTensor = 1; % for sure, just confirmation just in case
    if cfg.sphereModel == 1 % sphere model
        % Define the conductivity tensor  :
        cfg = bst_generate_tensor_on_elem(cfg);
        %% Check the size of the tensor :
        if ~(length(cfg.conductivity_tensor) == length(cfg.elem))
            error(' The size of the tensor is different to the size of elem')
        end
    else               % realistic head model
        % TODO : read the tensror from the DTI output or from the template
        % TODO : display tensor as elipsoid
    end
end

end