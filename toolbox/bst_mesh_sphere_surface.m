function [node, face, cfg] = bst_mesh_sphere_surface(cfg)

% Example
% cfg.c0=[0,0,0];
% cfg.r=0.1;
% cfg.tsize=r/10;
% cfg.maxvol=r/1000;
% cfg.rayons = [0.065 0.071 0.075 0.080];
% cfg.plotMesh = 1;


if ~isfield(cfg,'sphereCenter');   cfg.sphereCenter=[0,0,0]; end
if ~isfield(cfg,'tsize');   cfg.tsize=1; end
if ~isfield(cfg,'maxvol');   cfg.maxvol=1/3; end
if ~isfield(cfg,'sphereRadii');   cfg.sphereRadii = [0.065 0.071 0.075 0.080]; end
if ~isfield(cfg,'plotMesh');   cfg.plotMesh = 1; end
if ~isfield(cfg,'factor_bst') ; cfg.factor_bst =1.e-6; end

cfg.numberOfLayer = length(cfg.sphereRadii);
%% Creation du maillage de la sphére:
c0=cfg.sphereCenter;
% r=cfg.r;
tsize=cfg.tsize*cfg.factor_bst ;
maxvol=cfg.maxvol*cfg.factor_bst ;
% sphereRadii = cfg.sphereRadii;
plotMesh = cfg.plotMesh;
%% sphere 1
r1= cfg.sphereRadii(1);
[node1,face1,elem1]=meshasphere(cfg.sphereCenter,r1,tsize,maxvol);
%figure;plotmesh(node1,face1,elem1,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
surf1=volface(elem1);[nf1,ff1]=removeisolatednode(node1,surf1);
%figure;plotmesh(nf1,ff1,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');

%% sphere 2
if length(cfg.sphereRadii ) >= 2
r2= cfg.sphereRadii(2);
[node2,face2,elem2]=meshasphere(cfg.sphereCenter,r2,tsize,maxvol);
%figure;plotmesh(node2,face2,elem2,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
surf2=volface(elem2);[nf2,ff2]=removeisolatednode(node2,surf2);
%figure;plotmesh(nf2,ff2,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
end
%% sphere 3
if length(cfg.sphereRadii ) >= 3
    r3= cfg.sphereRadii(3);
[node3,face3,elem3]=meshasphere(cfg.sphereCenter,r3,tsize,maxvol);
%figure;plotmesh(node3,face3,elem3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
surf3=volface(elem3);[nf3,ff3]=removeisolatednode(node3,surf3);
%figure;plotmesh(nf3,ff3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
end
%% sphere 4
if length(cfg.sphereRadii ) >= 4
r4=  cfg.sphereRadii(4);
[node4,face4,elem4]=meshasphere(cfg.sphereCenter,r4,tsize,maxvol);
%figure;plotmesh(node3,face3,elem3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
surf4=volface(elem4);[nf4,ff4]=removeisolatednode(node4,surf4);
%figure;plotmesh(nf3,ff3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
end
%% sphere 5
if length(cfg.sphereRadii ) >= 5
r5=  cfg.sphereRadii(5);
[node5,face5,elem5]=meshasphere(cfg.sphereCenter,r5,tsize,maxvol);
%figure;plotmesh(node3,face3,elem3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
surf5=volface(elem5);[nf5,ff5]=removeisolatednode(node5,surf5);
%figure;plotmesh(nf3,ff3,'x<0');grid;xlabel('x');ylabel('y');zlabel('z');
end

%% Assemblage des spheres
if length(cfg.sphereRadii ) >= 2
[node, face]=mergemesh(nf1,ff1,nf2,ff2);
end
if length(cfg.sphereRadii ) >= 3
[node, face]=mergemesh(nf1,ff1,nf2,ff2,nf3,ff3);
end
if length(cfg.sphereRadii ) >= 4
[node, face]=mergemesh(nf1,ff1,nf2,ff2,nf3,ff3,nf4,ff4);
end
if length(cfg.sphereRadii ) >= 5
[node, face]=mergemesh(nf1,ff1,nf2,ff2,nf3,ff3,nf4,ff4,nf5,ff5);
end
if cfg.plotMesh == 1 ; figure;plotmesh(node, face,'x<0');grid;xlabel('x');ylabel('y');zlabel('z'); end
cfg.node = node; cfg.face = face;
end