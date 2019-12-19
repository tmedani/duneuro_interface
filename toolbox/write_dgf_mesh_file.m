function write_dgf_mesh_file(newnode,newelem,fname)
% write_dgf_mesh_file(newnode,newelem,fname)
% write the mesh file with the dgf format. 
% This format is used for the hexahedral mesh.
% It used by the duneuro as input for the head model.
% input : 
% newnode: list of the nodes, Nnode x 3
% newelem: list of the elements, Nelement x 3
% fname: string, nqme of the output file, 
% output : 
% file in the current directory with the name fname and extention dgf

% Takfarinas Medani, created December, 2019,

%%
% Check the formqt of the mesh
if size(newelem,2) ~= 8
    error('This mesh is not hexahedral ... This function is not adapted');
end
% Check filenmae extention
[~,name,ext] = fileparts(fname);
if isempty(ext) || ~strcmp(ext,'.dgf')
    ext = '.dgf';
end
fname = [name ext];
% ouvre ou cr�e un fichier
fid = fopen(fname,'wt');
% initialisation 
fprintf(fid,'%s\r\n','DGF');
% bloc des noeuds
fprintf(fid,'%s\r\n','Vertex');
fprintf(fid,'%i  %i  %i  \r\n',[newnode(:,1),newnode(:,2),newnode(:,3)]');
fprintf(fid,'%s\r\n','#');
% fin bloc des noeuds
% bloc des elements
fprintf(fid,'%s\r\n','Cube');Cube
fprintf(fid,'%s\r\n','parameters 1');
fprintf(fid,fid,'%i  %i  %i  %i  %i  %i  %i  %i  %i \r\n',...
                [newelem(:,1),newelem(:,2),newelem(:,3), newelem(:,4)...
                 newelem(:,5),newelem(:,6),newelem(:,7), newelem(:,8)]');
fprintf(fid,'%s\r\n','#');
% fin bloc des elements
fclose(fid);
end

