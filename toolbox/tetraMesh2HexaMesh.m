clear all; close all;
%% Example converting a single tetrahedron to 4 hexahedrons
c0 = [0 0 0];
r = 1;
tsize = 10;
maxvol = tsize;
[node0,face0,elem0]=meshasphere(c0,r,tsize,maxvol);
[node1,face1,elem1]=meshasphere(c0,1.2*r,tsize,maxvol);
[newnode,newelem]=mergemesh(node0,face0,node1,face1);
[node,elem,face] = s2m(newnode,newelem,1,maxvol,'tetgen',[0 0 0;1.1 0 0],[]);
figure; plotmesh(node,elem, 'x>0')

femmatTetraOriginal.Elements = elem(:,1:4);
femmatTetraOriginal.Vertices = node;
femmatTetraOriginal.Tissus = elem(:,5);
femmatTetraOriginal.Comment = 'femmatTetraOriginal' ; 
femmatTetraOriginal.History = [] ; 

%% Convert tetrahedron to hexahedral elements
TetraID = 1 : length(elem);
% TetraID = 1 : 2;
% Convert the elements and nodes
[elemeHexa,nodeHexa] = tet2hex(elem(TetraID,1:4),node);
% Convert the lables
temp_labelTetra = elem(TetraID,5);
temp = repmat(temp_labelTetra,1,4); temp = temp';
labelHexa = temp(:);
% Finale mesh
femmatHexaConverted.Elements = elemeHexa;
femmatHexaConverted.Vertices = nodeHexa;
femmatHexaConverted.Tissus = labelHexa;
femmatHexaConverted.Comment = 'femmatHexaConverted';
femmatHexaConverted.History = [];

figure; 
subplot(1,2,1); plotmesh(node,[elem(TetraID,1:4) temp_labelTetra])
subplot(1,2,2); plotmesh(nodeHexa(elemeHexa,:),'k.')
%% Convert hexahedral to tetrahedron
HexaID = 1 : length(elemeHexa);
% HexaID = [5 5];
% Convert the elements and nodes
[elemeTetra,nodeTetra] = hex2tet(elemeHexa(HexaID,1:8),nodeHexa ,[],4);
% Convert the lables
temp_labelHexa = labelHexa(HexaID);
temp = repmat(temp_labelHexa,1,5); temp = temp';
labelTetraConverted = temp(:);

figure; 
subplot(1,2,1); plotmesh(nodeHexa,[elemeTetra labelTetraConverted])

% Finale mesh
femmatTetraConverted.Elements = elemeTetra;
femmatTetraConverted.Vertices = nodeTetra;
femmatTetraConverted.Tissus = labelTetraConverted;
femmatTetraConverted.Comment = 'femmatTetraConverted';
femmatTetraConverted.History = [];







if size(elem,2) == 5;
    label = elem(elemID,5);
else
    label = ones(length(elem),1);
end
y = repmat(label,1,4); y = y';
hexaLabel= y(:);
%% Hexa mesh
hexaNode = Vs;
hexaElem = Es;
hexaLabel = hexaLabel;

%% Display model
figure;
plotmesh(node,element2patch(elem(elemID,:)),'facealpha',0.3)
hold on
plotmesh(node(elem(elemID,1:4),:),'ro')
%  hold on
%  plotmesh(node,[elem(elemID,:) ones(size(elemID))'],'facealpha',0.3,'facecolor','b')
hold on
plotmesh(hexaNode(hexaElem,:),'k.');
% add the hexa edges
[Fs]=element2patch(hexaElem); %Patch data for plotting
label = elem(elemID,5);
size(Fs)
label = label';
y = repmat(label,1,24);
CFs = y(:);
size(CFs)
hold on ; %figure;
% plotmesh(Vs,[Fs,CFs]);
faceAlpha = 0.3;
gpatch(Fs,hexaNode,CFs,'k',faceAlpha,1);


% convert the mesh to tetra for diplay purpose
[tetraElem,tetraNode,tetraLabel] = hex2tet(hexaElem,hexaNode ,hexaLabel,4);
figure; plotmesh(tetraNode, [tetraElem tetraLabel] )
% updates FemMat for display purpose

%%%%

%% Hexa mesh
elemID = 4:120;
hexaNode = Vs;
hexaElem = Es(elemID,:);
label = hexaLabel(elemID);

%% Display model
figure;
hold on
plotmesh(hexaNode(hexaElem,:),'ro');
% add the hexa edges
[Fs]=element2patch(hexaElem); %Patch data for plotting
% label = hexaLabel;
% label = label';
y = repmat(label,1,6);%y =y';
CFs = y(:);
size(CFs)
hold on ; %figure;
% plotmesh(Vs,[Fs,CFs]);
faceAlpha = 0.3;
hold on;gpatch(Fs,hexaNode,CFs,'k',faceAlpha,1);
% hold on; plotmesh(hexaNode,[Fs CFs],'facealpha',1)

% convert the mesh to tetra for diplay purpose
[tetraElem,tetraNode,tetraLabel] = hex2tet(hexaElem,hexaNode ,label,4);
sfigure; plotmesh(tetraNode, [tetraElem tetraLabel] )
% updates FemMat for display purpose






