function bst_display_electrical_potential(cfg,opts)
% Display the potential disatribution on the EEG cap
%cfg : the main configuration structure usd in the this toolbox
% opts.sourceIndex : index of the source to be displayed/activated tha generate the electrical potial which is displayed % = 1 :10;
% opts.sourceIndex : if it a single index, this function display only the
% the electrical of this source. If it's more thant one index, the display
% is the mean contibution of all these sources index (by default)
% opts.lf_to_display : name of the field that contain the leadfield results % = cfg.lf_bem : ;
% opts.method : string, either one of these :  {'mean', 'max', 'min', 'sum', 'all'}

if ischar(opts.sourceIndex)
    if strcmp(opts.sourceIndex,'all')
        opts.sourceIndex = 1 : length(cfg.sourceSpace);
    end
end

triElec = delaunay(cfg.channelLoc(:,1), cfg.channelLoc(:,2), cfg.channelLoc(:,3));% Pour relier les point et former des elemnt volumique
openface1=volface(triElec);

if length(opts.sourceIndex) == 1
    disp(['Potential for the ' (num2str(length(opts.sourceIndex))) ' dipoles'])
    opts.method = num2str(opts.sourceIndex);
    elecPot = opts.lf_to_display(:, opts.sourceIndex);
end

if ~isfield(opts,'method')
    opts.method = 'mean';
    disp([opts.method ' potential for the ' (num2str(length(opts.sourceIndex))) ' dipoles'])
    
    if length(opts.sourceIndex) > 1
        elecPot = mean(opts.lf_to_display(:, opts.sourceIndex),2);
    end
end

if isfield(opts,'method')
    disp([opts.method ' potential for the ' (num2str(length(opts.sourceIndex))) ' dipoles'])
    
    if length(opts.sourceIndex) > 1
        switch opts.method
            case 'mean'
                elecPot = mean(opts.lf_to_display(:, opts.sourceIndex),2);
            case 'sum'
                elecPot = sum(opts.lf_to_display(:, opts.sourceIndex),2);
            case 'all'
                elecPot = sum(opts.lf_to_display(:, opts.sourceIndex),2);
            case 'max'
                elecPot = max(opts.lf_to_display(:, opts.sourceIndex),2);
            case 'min'
                elecPot = min(opts.lf_to_display(:, opts.sourceIndex),2);
            otherwise
                error('method is not recognized, please correct opts.method')
        end
    end
end



figure('Color',[1 1 1]);%set(f15,'visible','off');set(f15,'Units','Normalized','Outerposition',[0 0 1 1]);
p00=plotmesh([ cfg.channelLoc elecPot],openface1);view(2);

set(p00,'EdgeColor','none')
% title(['view of the electrical potential with : ' opts.method '; ' (num2str(length(opts.sourceIndex)))  ' dipole(s)']);
xlabel('Axe X');ylabel('Axe Y');zlabel('Axe Z');
colorbar
%set(v3,'Units','Normalized','Outerposition',[0 0 1 1]);

end