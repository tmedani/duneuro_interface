function cfg = bst_display_tensor_as_mainEigenVector(cfg)

% compute eigen value and vector of a matrix


% check this for more option in the future : http://web.mit.edu/8.13/matlab/MatlabTraining_IAP_2012/AGV/DemoFiles/ScriptFiles/html/Part8_VectorFields.html


if ~isfield(cfg,'conductivity_eigenVector')
    disp('Compute Eigen Value and Eigen Vector ... may takes long time')
    cfg = bst_compute_eigen_value_vector(cfg);
end

cfg.conductivity_eigenVector;
cfg.conductivity_eigenValue;

indElem = cfg.indElem;
% get the centroide
x = cfg.elem_centroide(indElem,1);
y = cfg.elem_centroide(indElem,2);
z = cfg.elem_centroide(indElem,3);

% Get the eigen values and vectors
V1 = cfg.conductivity_eigenVector(:,1,indElem); V1 = squeeze(V1);
V2 = cfg.conductivity_eigenVector(:,2,indElem); V2= squeeze(V2);
V3 = cfg.conductivity_eigenVector(:,3,indElem); V3 = squeeze(V3);
V = {V1;V2;V3};
L1 = cfg.conductivity_eigenValue(1,1,indElem); L1 = squeeze(L1);
L2 = cfg.conductivity_eigenValue(2,2,indElem); L2 = squeeze(L2);
L3 = cfg.conductivity_eigenValue(3,3,indElem); L3 = squeeze(L3);

V1xL1 = cfg.conductivity_eigenVectorScaledByValue(:,1,indElem); V1xL1 = squeeze(V1xL1);
V2xL2 = cfg.conductivity_eigenVectorScaledByValue(:,2,indElem); V2xL2 = squeeze(V2xL2);
V3xL3 = cfg.conductivity_eigenVectorScaledByValue(:,3,indElem); V3xL3 = squeeze(V3xL3);
VxL = {V1xL1;V2xL2;V3xL3};
% Get the maximum values and main direction
[~, mainDirection] = max([L1';L2';L3']);

VmainDirectionScalled = VxL{mainDirection};
VmainDirection = V{mainDirection};


figure;
quiver3(x,y,z,VmainDirectionScalled(1,:)',VmainDirectionScalled(2,:)',VmainDirectionScalled(3,:)','linewidth',1,'color','k');
% hold on
% quiver3(x,y,z,VmainDirection(1,:)',VmainDirection(2,:)',VmainDirection(3,:)','linewidth',1,'color','r');    hold on;
hold on;
plotmesh(cfg.node,cfg.elem(indElem,:),'facealpha',0.3);  hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')


[cx, cy, cz] = meshgrid([-1 0 1]);
h = coneplot(x, y, z, VmainDirectionScalled(1,:)',VmainDirectionScalled(2,:)',VmainDirectionScalled(3,:)', cx, cy, cz, 5);
set(h, 'FaceColor', 'r', 'EdgeColor', 'none');
camlight; lighting gouraud;

end
% figure;
% quiver3(x,y,z,V1(1),V1(2),V1(3),'linewidth',1,'color',VectorColor{1});    hold on;
% quiver3(x,y,z,V2(1),V2(2),V2(3),'linewidth',1,'color',VectorColor{2});    hold on;
% quiver3(x,y,z,V3(1),V3(2),V3(3),'linewidth',1,'color',VectorColor{3});    hold on;
%
% % scaled by the eigen value
% quiver3(x,y,z,L1*V1(1),L1*V1(2),L1*V1(3),'linewidth',1,'color','k');    hold on;
% quiver3(x,y,z,L2*V2(1),L2*V2(2),L2*V2(3),'linewidth',1,'color','k');    hold on;
% quiver3(x,y,z,L3*V3(1),L3*V3(2),L3*V3(3),'linewidth',1,'color','k');    hold on;

