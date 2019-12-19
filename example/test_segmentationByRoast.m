% teste roast segmentation 
clear all; close all
fullPathToT1 = 'C:\Users\MEDANI-BCI\Documents\MATLAB\testSegmentation\ernie_T1.nii';
fullPathToT2 = 'C:\Users\MEDANI-BCI\Documents\MATLAB\testSegmentation\bert_T2_org_nonan.nii';

segment_by_roast(fullPathToT1,fullPathToT2)

% mesh
[node,elem,face,allMask] = mesh_by_iso2mesh(fullPathToT1,fullPathToT2);

%% STEP 3: MESH VISUALISATION...
disp('======================================================')
disp('   VISUALISATION OF THE MESH    ')
disp('======================================================')
maskName = {'WHITE','GRAY','CSF','BONE','SKIN'};
skin_mesh_clr         = [255 213 119]/255; bone_mesh_clr  = [140  85  85]/255;
csf_mesh_clr  = [202 50 150]/255;grey_mesh_clr = [150 150 150]/255;
white_mesh_clr = [250 250 250]/255;
couleur=[skin_mesh_clr;bone_mesh_clr;csf_mesh_clr;grey_mesh_clr;white_mesh_clr];
face_color = couleur;
figure
for i=1:length(maskName)
    hold on
    indElem = find(elem(:,5) == i);
    indFace = find(face(:,4) == i);
    %     plotmesh(node(:,1:3),face(indFace,:),elem(indElem,:))
    plotmesh(node(:,1:3),elem(indElem,:),'z<120 & x>80','facecolor',face_color(6-i,:) )
    %title([maskName{i} ' id = ' num2str(i)])
    %pause
end
legend({'WHITE','GRAY','CSF','BONE','SKIN'})
title(['Model '  num2str(model) '  ' baseFilename '  ' uniqueTag], 'Interpreter', 'none');

% plot the boundary surface of the generated mesh
allMaskd=double(allMask);
figure;
h=slice(allMaskd,[],[120],[120 180]);
set(h,'linestyle','none')
hold on
plotmesh(node(:,[2 1 3]),face,'facealpha',0.7);



%% Mesh by hexahedral by Johannes implementation

