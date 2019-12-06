function [u1, u2, u3] = bst_analytical_solution(cfg)
%%
% cfg.dip_position; % 3d
% cfg.center; % 3d
% cfg.elec_position; % 3d
% cfg.conductivity; 
% cfg.dip_orientation; % 3d

Rq=cfg.dip_position + 1.e-10;% [0 0 0]+1.e-10; %position de la source
Re= cfg.elec_position; %elec;%noeuds; % position de l'ectrode
center= cfg.center; %c0+1.e-10;  % positiondu centre
sigma= cfg.conductivity; %[0.33 1 0.0042 0.33];% conductivité isotropic

x=Re;% position de point de calcul, electrode ou noeud en 3D x,y,z
q= cfg.dip_orientation; %[0,1,0];% strength of the moment dipole (moment en 3D mx,my,mz)
p=Rq; %position de la source en 3D x,y,z 
sigmas=sigma; % radial conductivities of layers
skull_factor = 1;
wm_factor = 1;
xis=[wm_factor*cfg.conductivity(1)  1 cfg.conductivity(3)*skull_factor 0.33]; % tangential conductivities of layers
rk = cfg.rayons ; % rk=[r1 r2 r3 r4]; % rayon des sphére dans l'ordre croissant % The radii of the spheres are given by a vector rk in ascending order

clear u1 u2 u3;close all;clc

%% f1 solution anisotrop
u1=om_spher_pot_aniso(x,q,p,sigmas,xis,rk) ;

%figure;plotmesh([noeuds u1], faces,'x<0')

%%f2 solution isotrop
u2 = om_spher_pot_iso(x,q,p,sigmas,rk);
%figure;plotmesh([noeuds u2], faces,'x<0')

%% f3
R=rk;
Rq;
G = bst_eeg_sph(Rq, Re, center, R, sigma);
u3=G*q';
%figure;plotmesh([noeuds u3], faces,'x<0')

figure;plot(u1,'ro');hold on;plot(u2,'bx');hold on;plot(u3,'ks');legend('OM ANI','OM ISO','BST ISO');grid;
figure;plot(zscore(u1),'ro');hold on;plot(zscore(u2),'bx');hold on;plot(zscore(u3),'ks');legend('zs OM ANI','zs OM ISO','zs BST ISO');grid;
end