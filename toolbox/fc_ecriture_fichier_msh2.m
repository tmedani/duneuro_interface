function fc_ecriture_fichier_msh2(newnode,newelem,Vn,fname)

% fc_ecriture_fichier_msh(node,elem,Vn,fname)
% Cette fonction permet de cr�er le fichier maillage *.msh qui sera lu par
% le soft gmesh, elle prend en entr�e la liste des neouds sous la
% forme [num_node xn yn zn] et la liste des element sous la forme [num_elem
% n1 n2 n3 n4 id], le nom du fichier de sortie est 'fname'
% Une fois lancer, la fonction lit le fichier de sortie du code FEM
% de zhuxiang, et permet de lire le potentiel de cuaque noeud.
% Elle ne fonction uniquement avec les donnes de potentiel asoci�e au meme
% maillage
% cette fonction prend en entr� la liste des noeuds de maillage node,
% le potentiel associ�e a chaque noeud , et la liste des elements du maillage.
%http://www.ensta-paristech.fr/~kielbasi/docs/gmsh.pdf

% Takfarinas Medani, created 2015,
% last update 05/12/2019
% faster without for loops and duplicate matrix (less memory)

% Nombre_de_noeuds=length(newnode);
Nombre_des_elements=length(newelem);
% newnode=node;
% newelem=elem;
% nn=newnode(:,1);% num�ro du noeud
% xn=newnode(:,2);% composante x du noeud
% yn=newnode(:,3);% composante y du noeud
% zn=newnode(:,4);% composante y du noeud

% %ouvre ou cr�e un fichier
fid = fopen(fname,'wt');

%% Informations du format du fichier de maillage
fprintf(fid,'%s\r\n','$MeshFormat');
fprintf(fid,'%s\r\n','2.2 0 8');
fprintf(fid,'%s\r\n','$EndMeshFormat ');
%% bloc des noeuds
fprintf(fid,'%s\r\n','$Nodes ');
%fprintf(fid,'%s\r\n',' Dimension    {3}  ');
%fprintf(fid,'\r\n');
fprintf(fid,'%i \r\n',length(newnode));
%�criture des noeuds ligne par ligne nn xn yn zn
% for i=1:Nombre_de_noeuds
%     fprintf(fid,'%i  %i  %i  %i \r\n',nn(i),xn(i),yn(i),zn(i));
% end
% fprintf(fid,'%i  %i  %i  %i \r\n',[nn,xn,yn,zn]');
fprintf(fid,'%i  %i  %i  %i \r\n',[newnode(:,1),newnode(:,2),newnode(:,3),newnode(:,4)]');
fprintf(fid,'%s\r\n','$EndNodes');

%% bloc des elemnts
%ecriture de la partie II du fichier d'entr�e
% ne=newelem(:,1); %Num�ro de l'element
% ne1=newelem(:,2); %premier noeud de l'�l�ment
% ne2=newelem(:,3); %2 �me  //     //
% ne3=newelem(:,4); %3 �me  //     //
% ne4=newelem(:,5); %4 �me  //     //
% ne5=newelem(:,6); % domaine ID du materiau

elm_type_segment=1;
elm_type_triangle=2;
elm_type_quadrangle=3;
elm_type_tetra=4;

fprintf(fid,'\r\n');
fprintf(fid,'%s\r\n','$Elements');
fprintf(fid,'%i \r\n',Nombre_des_elements);

% for i=1:Nombre_des_elements
%    %fprintf(fid,'%i %i %s  %i  %i  %i %i  %i %i \r\n',ne(i),elm_type_tetra,'2',0 ,ne5(i),ne1(i),ne2(i),ne3(i),ne4(i));
%     fprintf(fid,'%i %i %s  %i  %i  %i %i  %i %i \r\n',ne(i),elm_type_tetra,'2',ne5(i)-1,0,ne1(i),ne2(i),ne3(i),ne4(i)); % modification of TIM
% end
fprintf(fid,'%i %i %i  %i  %i  %i %i  %i %i \r\n',[newelem(:,1),elm_type_tetra*ones(size(ne)),2*ones(size(ne)),ne5-1,0*ones(size(ne)),...
                                                                            newelem(:,2),newelem(:,3),newelem(:,4),newelem(:,5)]'); % modification of TIM
fprintf(fid,'%s\r\n','$EndElements');


%% bloc physical Names
fprintf(fid,'%s\r\n','$PhysicalNames');
% nombre_de_couches = length(unique(newelem(:,6)));
fprintf(fid,'%i \r\n',length(unique(newelem(:,6))));
fprintf(fid,'%i %i %s\r\n','1 1 toto1');
fprintf(fid,'%i %i %s\r\n','2 2 toto2');
fprintf(fid,'%i %i %s\r\n','3 3 toto3');
fprintf(fid,'%i %i %s\r\n','4 4 toto4');
fprintf(fid,'%s\r\n','$EndPhysicalNames');


%% $NodeData
% http://geuz.org/gmsh/doc/texinfo/gmsh.html#SEC62
fprintf(fid,'%s\r\n','$NodeData');
fprintf(fid,'%i \r\n',1); % one string tag:
fprintf(fid,'%s\r\n','"A scalar view"');
fprintf(fid,'%i\r\n',1); %one real tag:
fprintf(fid,'%i\r\n',0.0); %the time value (0.0)
fprintf(fid,'%i\r\n',3); % three integer tags:
fprintf(fid,'%i\r\n',0); %the time step (0; time steps always start at 0)
fprintf(fid,'%i\r\n',1); % 1-component (scalar) field
fprintf(fid,'%i\r\n',length(newnode)); % nb associated nodal values

%Vn=fc_nodal_potential();
% for i=1:Nombre_de_noeuds
%     fprintf(fid,'%i %i \r\n',nn(i),Vn(i)-Vn(1));
% end
fprintf(fid,'%i %i \r\n',[nn,Vn']');
fprintf(fid,'%s\r\n','$End$NodeData');
fclose(fid);
end


