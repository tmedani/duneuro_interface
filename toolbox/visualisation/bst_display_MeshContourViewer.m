function cfg = bst_display_MeshContourViewer(cfg,opts)


% 
% opts.axialValue = 0.1;
% opts.coronalValue =  0.1;
% opts.saggitalValue =  0.1;
% cfg = bst_display_MeshContourViewer(cfg,opts);

figure;
subplot(2,2,1)
opts.crossPlanName = 'coronal'; % string:
opts.crossPlanValue = opts.coronalValue; % y vlue
bst_display_Mesh2TissuContour(cfg,opts);
subplot(2,2,2)
opts.crossPlanName = 'saggital'; % string:
opts.crossPlanValue = opts.saggitalValue; % x vlue
bst_display_Mesh2TissuContour(cfg,opts);
subplot(2,2,3)
opts.crossPlanName = 'axial'; % string:
opts.crossPlanValue = opts.axialValue ; % z vlue
bst_display_Mesh2TissuContour(cfg,opts);
end