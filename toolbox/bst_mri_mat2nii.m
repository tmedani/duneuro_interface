function bst_mri_mat2nii(sMri,OutputFile)
% convert the brainstorm matlab mri file to nii format 
% sMri = path and name to the input image 'subjectimage_BCI-DNI_brain.mat'
% OutputFile = path and name to the output file 'subjectimage_BCI-DNI_brain.nii'
% call brainstron function
% out_mri_nii1 version modified of out_mri_nii at line 58 : in_mri_bst by in_mri_bst1
% in_mri_bst1 version modified of  in_mri_bst by removing the test at 34 to 37
% The output of this function could be used for the segmentation with    

% sMri = 'subjectimage_BCI-DNI_brain.mat'
% OutputFile = 'G:\Mon Drive\bst_integration\othercodes\subjectimage_BCI-DNI_brain.nii'

% [fid, nifti] = out_mri_nii(sMri,OutputFile); error du to a test 

[fid, nifti] = out_mri_nii1(sMri,OutputFile);
end

% [Transf, sMri] = cs_compute(sMri, 'mni')

% if errors occures, just comment the line and check 