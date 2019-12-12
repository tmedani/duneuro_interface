function mesh_vox2scs(fileNameIn,bstMRI)

m=mesh_load_gmsh4(fileNameIn);

S = diag([bstMRI.Voxsize(:) ./ 1000; 1]);
T = [bstMRI.SCS.R, bstMRI.SCS.T./1000; 0 0 0 1];
vox2scs = T * S * inv(bstMRI.InitTransf{1,2});

mSCS=m;
vSCS = [m.nodes ones(size(m.nodes,1),1)];
vSCS = (vox2scs * vSCS')';
mSCS.nodes=vSCS(:,1:3);

[~,name,ext] = fileparts(fileNameIn);
mesh_save_gmsh4(mSCS,[name 'SCS' ext]);

end