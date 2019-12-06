function bst_display_tensor_as_vector(cfg)

%% display tensor
% input
%cfg.conductivity_tensor3x3;
%      conductivity_tensor3x3: [3󫢬7822 double]
%                                             3 composantes (x, y, z) x 3
%                                             vectors (Vx, Vy, Vz) x
%                                             NElement
% cfg.elem_centroide;
%
% cfg.indElem = 1:100; % will display the liste of the elements epscified in the indElem field


% TODO : extrqct the eigen vector, scal according to the eigen value and then plote them unstead to plot the tensor
if ~isfield(cfg,'indElem')
    randomPick = 50;
    indElem = randperm(length(cfg.elem),randomPick);
else
    indElem = cfg.indElem;
end
% position
x = cfg.elem_centroide(indElem,1);
y = cfg.elem_centroide(indElem,2);
z = cfg.elem_centroide(indElem,3);

figure;
VectorColor = {[1 0 0 ],[0 1 0],[0 0 1]};
for indVector = 1 : 3
    % compenent
    u =  squeeze(cfg.conductivity_tensor3x3(1,indVector, indElem));
    v =  squeeze(cfg.conductivity_tensor3x3(2,indVector,indElem));
    w =  squeeze(cfg.conductivity_tensor3x3(3,indVector,indElem));
    
%     [v,l]=eig(abs(cfg.conductivity_tensor3x3(:,indVector, indElem)));

    h(indVector) = quiver3(x,y,z,u,v,w,'linewidth',1,'color',VectorColor{indVector});
    hold on;
end
legend(h,{'V1','V2','V3'},'AutoUpdate','off')
axis vis3d; axis equal;
shg; rotate3d on;
hold on;
plotmesh(cfg.node,cfg.elem(indElem,:),'facealpha',0.3);  hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')

end
