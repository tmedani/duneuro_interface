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


if ~isfield(cfg,'plotMesh')
    cfg.plotMesh =1;
end

tissueColor = {'y','k','b','g','r'}

figure
for i = 1 : length(indElem)
disp( [ num2str(i) ' / ' num2str(length(indElem))]);
%     index = cfg.elem(indElem(i),5)
    if (cfg.elem(indElem(i),5) == 3)
        if isfield(cfg,'noCsf')
            if cfg.noCsf == 1
                continue
            end
        end
    end
    
    % position
    xc = cfg.elem_centroide(indElem(i),1);
    yc = cfg.elem_centroide(indElem(i),2);
    zc = cfg.elem_centroide(indElem(i),3);
    
%     disp(['tissues ' num2str(cfg.elem(i,end))])
    
    if isfield(cfg,'eigen')
        v = cfg.eigen.eigen_vector{ indElem(i)} ;
        %          l = 300*cfg.eigen.eigen_value{ indElem(i)} ;
        l = cfg.eigen.eigen_value{ indElem(i)};
%         [i max(l)  ]
    else
        % extract eigen vector and value
        %          [v,l]=eig(abs(cfg.conductivity_tensor3x3(:,:, indElem(i))));
        [v,l]=eig((cfg.conductivity_tensor3x3(:,:, indElem(i))));
        if ~isreal(v)
            v = [1 0 0; 0 1 0; 0 0 1];
            l = 1.0e-03 *[1 0 0; 0 1 0; 0 0 1];
        end
    end
    %% maybe to avoid the complex number !!
    %     v = real(v);
    %     l = real(l);
    % generate the grid
    if cfg.ellipse == 1
        hold on
        meshResolution = 10;
        conversion_m2mm = 1000;
        factor = 4; % 4 is the optimal value for the SCS coordinates
        factor = factor/conversion_m2mm; % this is done because the conductivity is on S/meter, otherwise the size of the ellipse is bigger than the head
        [X,Y,Z] = ellipsoid(0,0,0,factor*norm(l(1,1)),factor*norm(l(2,2)),factor*norm(l(3,3)),meshResolution);
        % figure; surf(X,Y,Z); xlabel('X'); ylabel('Y'); zlabel('Z');
        % rotation
        sz=size(X);
        for x=1:sz(1)
            for y=1:sz(2)
                A=[X(x,y) Y(x,y) Z(x,y)]';
                A= v*A;
                X(x,y)=A(1);Y(x,y)=A(2);Z(x,y)=A(3);
            end
        end
        % translation
        X=X+xc; Y=Y+yc; Z=Z+zc;
        %         [i cfg.elem(i,end)]
         h= surf(X,Y,Z);
%         	surf(sx*S(j)+X(j), sy*S(j)+Y(j), sz*S(j)+Z(j),...
% 		'LineStyle','none',...
% 		'FaceColor',C(j,:),...
% 		'FaceAlpha',transp);
        %        shading flat
        if cfg.elem(indElem(i),5) == 1
            h.FaceColor = abs([v(2,1) v(1,1)  v(3,1)]);
        else
            h.FaceColor = tissueColor{cfg.elem(indElem(i),5)};
        end
        h.LineStyle = 'none';        
    end
    
    if cfg.arrow == 1
        hold on
        %if ~v(1,1) == 1 && v(2,1) == 0 && v(3,1)==0
            quiver3(xc,yc,zc,v(1,1)*l(1,1),v(2,1)*l(1,1),v(3,1)*l(1,1),5,'LineWidth', 1, 'Color',abs([v(2,1) v(1,1)  v(3,1)]));
            %         streamline(xc,yc,zc,v(1,1)*l(1,1),v(2,1)*l(1,1),v(3,1)*l(1,1),-1, 1, -1.5);
        %end
        plot3(xc,yc,zc,'k.')
    end
    
    hold on;
end

disp('Plotting ...');

if cfg.ellipse == 1
    %     shading interp
    %     colormap([0.8 0.8 0.8])
    lighting phong
    light('Position',[0 0 1],'Style','infinite')
    %     light('Position',[0 0 1],'Style','infinite','Color',[ 1.000 0.584 0.000]);
    
    % from scatter 
%     daspect([ratios(1), ratios(2), ratios(3)]);
% light('Position',[1 1 1],'Style','infinit','Color',[1 1 1]);
% lighting gouraud;
% view(30,30)
    
end
axis equal
xlabel('x');ylabel('y');zlabel('z');


if  cfg.plotMesh == 1
    shg; rotate3d on;
    if size(cfg.elem,2) == 9
        % convert to tetra
        [tetraElem,tetraNode,tetraLabel] = hex2tet(double(cfg.elem(:,1:end-1)), cfg.node, double(cfg.elem(:,end)), 3);
    else
        % hold on; plotmesh(cfg.node,cfg.elem(indElem,:),'facealpha',0.2); % hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')
        tetraElem = cfg.elem(:,1:end-1);
        tetraNode = cfg.node;
        tetraLabel = cfg.elem(:,end);
    end
    
    %     hold on; plotmesh(tetraNode,[tetraElem, tetraLabel],'y>0','facealpha',0.1,'edgecolor','none','facecolor',[0.9 0.9 0.9]);
    hold on; plotmesh(tetraNode,[tetraElem, tetraLabel],'y>0','facealpha',0.3,'edgecolor','none');
    view([90 0 0])
        % hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')
    %     hold on; plotmesh(tetraNode,[tetraElem, tetraLabel],'x>50'); % hold on;plotmesh(cfg.elem_centroide(indElem,:),'k.')    
end
axis equal
tissueColor = {'y','k','b','g','r'}
tissuenME = {'WM','GM','CSF','SKULL','SCALP'}
% cfg.conductivity*1000

end
