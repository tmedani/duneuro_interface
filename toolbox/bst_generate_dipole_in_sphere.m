function cfg = bst_generate_dipole_in_sphere(cfg)
% generate random dipole within the inner sphere

% TODO : generate more source near the inner and check if they are in.


if ~isfield(cfg,'numberOfDipole'); cfg.numberOfDipole = 25; end

r0 = cfg.sphereRadii(1);
c0 = cfg.sphereCenter;

p0 = [0 0 r0];

xp = [c0(1): r0/50:r0/3 c0(1): -r0/40:-r0/3  ]; % divid by 3 to ensore that the max is inside the sphere radii of sphere of
yp = [c0(2): r0/100:r0/3 c0(2): -r0/100:r0/3];
zp = [c0(3): r0/700:r0/3 c0(3): -r0/700:r0/3];

Xp = xp(randperm(length(xp),cfg.numberOfDipole));
Yp = yp(randperm(length(yp),cfg.numberOfDipole));
Zp = zp(randperm(length(zp),cfg.numberOfDipole));

cfg.sourceSpace = [Xp' Yp' Zp'];

figure;
plotmesh(cfg.node,cfg.elem(cfg.elem(:,5)==1,:),'facealpha',0.3);
hold on
plotmesh(cfg.sourceSpace,'ro' )
end