function bst_display_leadField_vector(cfg,opts)
% TODO : finish and comments
% Input
% opts.computed_solution1 = opts.lf_fem_simbio;
% opts.computed_solution1_name = 'SimBio';
%
%  opts.computed_solution2 = opts.lf_bem;
%  opts.computed_solution2_name = 'OpenMeeg';

%  opts.computed_solution3 = opts.lf_bem;
%  opts.computed_solution3_name = 'OpenMeeg';
%
%  opts.computed_solution4 = opts.lf_bem;
%  opts.computed_solution4_name = 'OpenMeeg';

%  % select the reference
% opts.targetElectrode = 3;
% opts.referenceElectrode = 2;
% opts.referenceModel = 1; % 1 or 2 : ! for average reference electrode, 2 for selecting a reference electrode
%



disp('Load the surface mesh')
if isfield(cfg,'cfg.bemNode')
    disp('Super the surface mesh is available')
else
    disp('Oups the surface mesh is not available ... I need to extract it from the volume ...')
    % Extrat the surface
    cfg = bst_extract_surface_from_volume(cfg);
end

%% Start from here
ref_mode =  {'avgref','ref'};

iref = opts.referenceElectrode ; % 3;
ielec = opts.targetElectrode; %2;
ref_mode = ref_mode{opts.referenceModel};
% Source Space
GridLoc = cfg.sourceSpace';
% sensor locations
SensorLoc = cfg.channelLoc';
% head model surfaces
HeadFV =  struct('faces',cfg.bemFace{3}, 'vertices',cfg.bemNode{3});
OuterFV = struct('faces',cfg.bemFace{2}, 'vertices',cfg.bemNode{2});
InnerFV =  struct('faces',cfg.bemFace{1}, 'vertices',cfg.bemNode{1});

LF(1) = {opts.computed_solution1}; LFnames(1) = {opts.computed_solution1_name}; LFcolor(1) = {[0 0 1]};
LF(2) = {opts.computed_solution2}; LFnames(2) = {opts.computed_solution2_name};LFcolor(2) = {[0 1 0]};
if isfield(opts,'computed_solution3')
    LF(3) = {opts.computed_solution3}; LFnames(3) ={ opts.computed_solution3_name};LFcolor(3) = {[1 0 0]};
end
if isfield(opts,'computed_solution4')
    LF(4) = {opts.computed_solution4}; LFnames(4) ={ opts.computed_solution4_name};LFcolor(4) = {[1 0 1]};
end
% LF = {opts.lf_ana_bst,opts.lf_fem_simbio};
% LFnames = {'OpenMEEG','DuNeuro'};

% view the head
figure
clf reset
h_h = patch(HeadFV,'facecolor','none','edgealpha',0.1);
h_o = patch(OuterFV,'facecolor','none','edgealpha',0.15);
h_i = patch(InnerFV,'facecolor','none','edgealpha',0.2);
axis vis3d, axis equal, rotate3d on, shg

% convenient for plotting command
X = GridLoc(1,:);Y = GridLoc(2,:); Z=GridLoc(3,:);

h = zeros(length(LF),1);
LeadField = cell(length(LF),1);

%% Plotting
hold on

for imodel = 1 : length(LF)
    switch ref_mode % {'avgref','ref'}
        case 'ref'
            LeadField{imodel} = LF{imodel}(ielec,:)- ...%  leadfield row
                LF{imodel}(iref,:); %  leadfield row
            
            %legendName = [{['TargetElectrode' num2str(ielec) ] ,'ReferenceElectrode'} LFnames ];
            titleName = [' Reference Electrode index = ' num2str(iref) ];
        case 'avgref'
            AvgRef = mean(LF{imodel},1);
            
            LeadField{imodel} = LF{imodel}(ielec,:)- ...%  leadfield row
                AvgRef; %  leadfield row
            titleName = [' Reference Electrode average '];
            %legendName = [{['TargetElectrode' num2str(ielec) ]} LFnames ];
    end
    LeadField{imodel} = reshape(LeadField{imodel},3,[]); % each column is a vector
    U = LeadField{imodel}(1,:);
    V = LeadField{imodel}(2,:);
    W =LeadField{imodel}(3,:); % convenient
    h(imodel) = quiver3(X,Y,Z,U,V,W);
    set(h(imodel),'linewidth',1,'color',LFcolor{imodel},'linewidth',2); % mark the electrode)
end

%hl =legend(h,LFnames);
% add the sensor locations
hold on
h(imodel+1) = plot3(SensorLoc(1,:),SensorLoc(2,:),SensorLoc(3,:),'ko','markersize',10);
hold on
h(imodel+2) = plot3(SensorLoc(1,ielec),SensorLoc(2,ielec),SensorLoc(3,ielec),'r*','markersize',15,'linewidth',2); % mark the electrode
hold on; plot3(SensorLoc(1,ielec),SensorLoc(2,ielec),SensorLoc(3,ielec),'ro','markersize',10,'linewidth',2); % mark the electrode
hl =legend(h,[LFnames,{'Sensor'},{'Target'}]);

if strcmp(ref_mode,'ref')
    hold on
    h(imodel+3) = plot3(SensorLoc(1,iref),SensorLoc(2,iref),SensorLoc(3,iref),'bo','markersize',10,'linewidth',2); % mark the electrode
    h(imodel+3) = plot3(SensorLoc(1,iref),SensorLoc(2,iref),SensorLoc(3,iref),'b+','markersize',15,'linewidth',2); % mark the electrode
    hl =legend(h,[LFnames,{'Sensor'},{'Target'},{'Reference'}]);    
end
set(hl,'fontsize',24)
rotate3d on;
title(titleName)
end