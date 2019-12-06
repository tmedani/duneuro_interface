function femhead = bst_convert_msh_to_bst(mshfilename)
% read, display and save to the bst matlab format
m = mesh_load_gmsh4(  mshfilename );

% volume mesh
femhead.Comment = mshfilename;
femhead.Vertices =   [m.nodes(:,2) m.nodes(:,1) m.nodes(:,3)]/1000;
femhead.Elements =   double([m.tetrahedra]);
femhead.Tissue =     double([m.tetrahedron_regions]);
for ind = 1 : length(femhead.Elements)
femhead.TissueLabels{ind} =  ['tissu_' num2str(ind)];
end
% femhead.TissueLabels = {'1 WM'; '2-GM'; '3-CSF'; '4-Skull'; '5-Scalp'; '6-Eyes'};
femhead.History =     [];
save(mshfilename,'femhead')

% tissu identification : 
Id = unique(femhead.Tissue ) ;
elem = femhead.Elements;

figure;
for ind1 = 1 : length(Id)
    plotmesh(femhead.Vertices ,[elem(femhead.Tissue== Id(ind1) , :) femhead.Tissue(femhead.Tissue== Id(ind1)) ],'x>0')
hold on
end
title(['model ' fnam{ind}  '  '  num2str(m.nodes) ' nodes']) 
end



