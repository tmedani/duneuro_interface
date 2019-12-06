function cfg = bst_compute_eigen_value_vector(cfg)
% input : cfg.conductivity_tensor3x3
% % output
% cfg.conductivity_eigenValue
% cfg.conductivity_eigenVector


cfg.conductivity_eigenValue = zeros(size(cfg.conductivity_tensor3x3));
cfg.conductivity_eigenVector = zeros(size(cfg.conductivity_tensor3x3));
cfg.conductivity_eigenVectorScaledByValue = zeros(size(cfg.conductivity_tensor3x3));
for indElem =1:size(cfg.conductivity_tensor3x3,3)
    % [V(:,:,indElem),D(:,:,indElem)] = eig(cfg.conductivity_tensor3x3(:,:,indElem));
    % [V,D] = eig(cfg.conductivity_tensor3x3(:,:,indElem));
[cfg.conductivity_eigenVector(:,:,indElem),...
        cfg.conductivity_eigenValue(:,:,indElem)] = eig(cfg.conductivity_tensor3x3(:,:,indElem));

cfg.conductivity_eigenVectorScaledByValue(:,:,indElem) =...
                                                                        [cfg.conductivity_eigenVector(:,1,indElem)*cfg.conductivity_eigenValue(1,1,indElem) ...
                                                                        cfg.conductivity_eigenVector(:,2,indElem)*cfg.conductivity_eigenValue(2,2,indElem) ...
                                                                        cfg.conductivity_eigenVector(:,3,indElem)*cfg.conductivity_eigenValue(3,3,indElem) ];
end

end
