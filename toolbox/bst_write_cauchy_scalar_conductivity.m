function bst_write_cauchy_scalar_conductivity(elem,conductivity_scalar,condfilename)

%% Write the CAUCHY Conductivity file
%bst_write_cauchy_tensor_conductivity(elem,tensor,confilename)
%geofilename = 'ca_conductivity.knw';
% inputs : elem
% geofilename = 'ca_main_mesh.geo'; string should have the name ca_mesh_XXX
% elem = model.volume.elem; list of elem Nex4 (or x5 with label) or Nex8
% (tetra ou hex) (or x9 with label)
% tensor should be a matrix with NbLayers x 6 % xx, yy, zz, xy, yz, zx or just a vector of 1 x 6 for each layer, which
% mean Nblayer x 6  in case of Nblayer layer
% model of tensor file : 
% BOI - SKALAR
%        1:  3.30000E-01       2:  3.30000E-01       3:  3.30000E-01
%        4:  3.30000E-01       5:  3.30000E-01       6:  3.30000E-01
%        7:  3.30000E-01       8:  3.30000E-01       9:  3.30000E-01

% example : 
%conductivity_scalar = [1 2 3]; %one single scalar value per layer.
% condfilename = 'ca_scalar.knw' ; 
% bst_write_cauchy_tensor_conductivity(elem,tensor,geofilename)

% Takfarinas MEDANI : Date of creation October 15th
% todo : check the extension of the file and set it to .knw

%% Read tensor
% xx, yy, zz, xy, yz, zx or just a vector of 1 x 6 for each layer, which
% mean Nbx6 layer in case of 6 layer
                      
% check the filename :
[filepath,name,ext] = fileparts(condfilename)
if ~strcmp(ext,'.knw')
    ext = '.knw'
end

name = [name '_scalar'];
filename = [name ext];

conductivity_scalar = reshape(conductivity_scalar,[],1);
%% Read elem
if size(elem,2)<7
    % tetra\
    disp('Tetra elements are detected')
    %elem = elem(:,1:4);
else
    % hexa
    disp('Hexa elements are detected')
    %elem = elem(:,1:8);
end

disp('Compare the nb of layer from the elements labels and the tensor')
if size(conductivity_scalar,1) ~= length(unique(elem(:,end)))
    disp(['There are ' num2str(size(conductivity_scalar,1)) ' conductivities tensors values for  '  num2str( length(unique(elem(:,end)))) ' layers']);
    error('The element id and the connectivity tensor are not the same')
else
    disp('The mesh model fits to the conductivity model');
    disp(['There are ' num2str(size(conductivity_scalar,1)) ' conductivities tensors values for ' num2str( length(unique(elem(:,end)))) ' layers']);
end

% elem index : 1 : Ne
% tensor
index_elem = 1 : length(elem); index_elem = index_elem';
value_line1 = [index_elem conductivity_scalar(elem(:,5),:)];
value_line1_reshaped = [];
disp('Reshape the vale cond')
for ind = 1 : 3 : size(value_line1,1)-2
    value_line1_reshaped = [value_line1_reshaped; value_line1(ind,:)  value_line1(ind+1,:)  value_line1(ind+2,:) ];
end


% write the file

fid = fopen(filename, 'w');
fprintf(fid, 'BOI - KNOTENWERTEFILE\n');
fprintf(fid, '========================================================\n');
fprintf(fid, '========================================================\n');
fprintf(fid,'BOI - SKALAR\n');
fprintf(fid,'         %d:  %1.5f       %d:  %1.5f       %d:  %1.5f\n', value_line1_reshaped');
fprintf(fid,' EOI - SKALAR\n');
fprintf(fid,' ========================================================\n');
fprintf(fid,' ========================================================\n');
fprintf(fid,' EOI - KNOTENWERTEFILE\n');
fclose(fid);
%fclose('all');
end
