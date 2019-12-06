function lf = bst_compute_lf_fieldtrip_eeg(cfg)

% call the fieldtrip function to compute analytical solution 
% eeg_leadfield4


vol.r =  cfg.sphereRadii;           vol.cond = cfg.conductivity;
vol.c0 =  cfg.sphereCenter;  


if length(cfg.sphereRadii)<4
    if length(cfg.sphereRadii) == 2
        vol.r = [vol.r (1) vol.r (2) vol.r (2) vol.r (2)];
        vol.cond  = [vol.cond (1) vol.cond (2) vol.cond (2) vol.cond (2)];        
    elseif length(cfg.sphereRadii) == 3
        vol.r = [vol.r(1) vol.r(2) vol.r(3) vol.r(3)];
        vol.cond  = [vol.cond(1) vol.cond(2) vol.cond(3) vol.cond(3)];        
    end
elseif  length(cfg.sphereRadii)>4
    error('Not suported, one shell is possible with fieldtrip, not here, more than four shells, check other tools')
end
    str = which('plgndr.m','-all');
    if isempty(str)
        error('The file plgndr.m is not found in your computer, you need to add download the fieltrip toolbox, or at least this folder \fieldtrip\private\plgndr.m ')
    end
    [FILEPATH,~,~] = fileparts(str{1});
    currentpath = pwd;
    cd(FILEPATH)
    lf = [];
    for ind = 1 : size(cfg.sourceSpace,1)
    [lf0, ~] = eeg_leadfield4(cfg.sourceSpace(ind,:), cfg.channelLoc, vol);
    lf = [lf lf0];
    end    
    cd(currentpath)
end