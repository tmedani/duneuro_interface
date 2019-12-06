function femhead = bst_msh2bst(mshfilename)
% convert the mat file to bst fem format 
% dependecies :  mesh_load_gmsh4
% Takfarinas MEDANI 9/19/2019
 
 m = load(mshfilename);
% covert to the bst format
femhead.Comment =mshfilename;
femhead.Vertices =   m.node(:,1:3)/1000;
femhead.Elements =    m.elem(:,1:4);
femhead.Tissue =     m.elem(:,5);
%femhead.TissueLabels = {'1-WM'; '2-GM'; '3-CSF'; '4-Skull'; '5-Scalp'; '6-Eyes'};
tissuID = length(unique(femhead.Tissue));
for ind = 1 : length(tissuID)
     femhead.TissueLabels{ind}  = [ 'tissu_' num2str(tissuID(ind))];
end
femhead.History =     [];
femhead.Faces = m.face; 
end