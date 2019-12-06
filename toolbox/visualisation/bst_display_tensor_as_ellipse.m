function bst_display_tensor_as_ellipse(cfg)

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


if ~isfield(cfg,'indElem')
    randomPick = 50;
    indElem = randperm(length(cfg.elem),randomPick);
    cfg.indElem = indElem;
else
    indElem = cfg.indElem;
end


figure
for i = 1:length(indElem)
    % position
    xc = cfg.elem_centroide(indElem(i),1);
    yc = cfg.elem_centroide(indElem(i),2);
    zc = cfg.elem_centroide(indElem(i),3);    
    % extract eigen vector and value
    [v,l]=eig(abs(cfg.conductivity_tensor3x3(:,:, indElem(i))));
    %% maybe to avoid the complex number !!
%     v = real(v);
%     l = real(l);
    meshResolution = 15;
    factor = 1;
    [X,Y,Z] = ellipsoid(0,0,0,factor*norm(l(1,1)),factor*norm(l(2,2)),factor*norm(l(3,3)),meshResolution);
    % figure; surf(X,Y,Z); xlabel('X'); ylabel('Y'); zlabel('Z');
        sz=size(X);
        for x=1:sz(1)
            for y=1:sz(2)
                A=[X(x,y) Y(x,y) Z(x,y)]';
                A=v*A;
                X(x,y)=A(1);Y(x,y)=A(2);Z(x,y)=A(3);
            end
        end
        X=X+xc; Y=Y+yc; Z=Z+zc;
        %figure ; surf(X,Y,Z); xlabel('X'); ylabel('Y'); zlabel('Z');    
    h(i)=surf(X,Y,Z);
    hold on;
end
shading interp
colormap([0.8 0.8 0.8])
lighting phong
light('Position',[0 0 1],'Style','infinite','Color',[ 1.000 0.584 0.000]);
axis equal

shg; rotate3d on;
hold on; plotmesh(cfg.node,cfg.elem(indElem,:),'facealpha',0.5); % hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')

end
