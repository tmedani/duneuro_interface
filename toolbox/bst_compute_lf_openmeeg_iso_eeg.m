function lf = bst_compute_lf_openmeeg_iso_eeg(cfg)
% call the openmeeg isotropic model

x=cfg.channelLoc;% position de point de calcul, electrode ou noeud en 3D x,y,z
sigmas=cfg.conductivity; % radial conductivities of layers
rk = cfg.sphereRadii;

q0= [1 0 0; 0 1 0; 0 0 1];%[0,1,0];% strength of the moment dipole (moment en 3D mx,my,mz)
p=[]; %position de la source en 3D x,y,z 
lf = [];
for dip_i = 1 : length(cfg.sourceSpace)
    p = cfg.sourceSpace(dip_i,:);
    for ori_j = 1 : 3
        q = q0(ori_j,:);
        lf0 = om_spher_pot_iso(x,q,p,sigmas,rk);
        lf = [lf lf0];
    end
end
end