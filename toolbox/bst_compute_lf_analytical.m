function cfg = bst_compute_lf_analytical(cfg)
% Call the analytical solution for the eeg lead field of the
% brainstorm, fieldtrip or openmeeeg.

if ~isfield(cfg,'isotropic') ; cfg.isotropic = 0; end

if ~isfield(cfg,'lfBstFormulation') ; cfg.lfBstFormulation = 1; end % bst formulation by default
if ~isfield(cfg,'lfFtpFormulation') ; cfg.lfFtpFormulation = 0; end
if ~isfield(cfg,'lfOmIFormulation') ; cfg.lfOmIFormulation = 0; end
if ~isfield(cfg,'lfOmAFormulation') ; cfg.lfOmAFormulation = 0; end

if cfg.isotropic == 0 % anisotrpic fomulation ... only openmeeg
    if ~isfield(cfg,'lfBstFormulation') ; cfg.lfBstFormulation = 0; end % bst formulation by default
    if ~isfield(cfg,'lfFtpFormulation') ; cfg.lfFtpFormulation = 0; end
    if ~isfield(cfg,'lfOmIFormulation') ; cfg.lfOmIFormulation = 0; end
    if ~isfield(cfg,'lfOmAFormulation') ; cfg.lfOmAFormulation = 1; end
end

if cfg.sphereModel ==1
    if cfg.lfBstFormulation == 1
        % Compute analytical solution from brainstorm, isotropic
        disp('Compute from brainstorm fomulation')
        lf_bst = bst_eeg_sph(cfg.sourceSpace, cfg.channelLoc , ...
            cfg.sphereCenter, cfg.sphereRadii, cfg.conductivity);
        
        if cfg.lfAvrgRef == 1
            lf_bst  = lf_bst  - (mean(lf_bst ,1));
            %lf_fem = lf_fem - lf_fem(1,:);
        end
        cfg.lf_ana_bst = lf_bst; clear lf_bst
    end
    if cfg.lfFtpFormulation == 1
        % Compute analytical solution from fieldtrip, isotropic
        disp('Compute using fieldtrip fomulation')
        % works only within this folder : bst_duneuro_toolbox\external_toolbox\fieldtrip\private
        lf_ftp = bst_compute_lf_fieldtrip_eeg(cfg);
        
        if cfg.lfAvrgRef == 1
            lf_ftp  = lf_ftp  - (mean(lf_ftp ,1));
            %lf_fem = lf_fem - lf_fem(1,:);
        end
        cfg.lf_ana_ftp = lf_ftp; clear lf_ftp
    end
    
    if cfg.lfOmIFormulation ==1
        % Compute analytical solution from openmeeg, isotrpic
        disp('Compute using openmeeg isotrpoic fomulation')
        lf_opi = bst_compute_lf_openmeeg_iso_eeg(cfg);
        
        if cfg.lfAvrgRef == 1
            lf_opi  = lf_opi  - (mean(lf_opi ,1));
            %lf_fem = lf_fem - lf_fem(1,:);
        end
        
        cfg.lf_ana_opi = lf_opi; clear lf_ftp
    end
    
    if cfg.lfOmAFormulation ==1
        % Compute analytical solution from openmeeg, anisotrpic
        if cfg.isotropic == 0
            disp('Compute using openmeeg anisotropic fomulation')
            lf_opa = bst_compute_lf_openmeeg_aniso_eeg(cfg);
            if cfg.lfAvrgRef == 1
                lf_opa  = lf_opa  - (mean(lf_opa ,1));
                %lf_fem = lf_fem - lf_fem(1,:);
            end
            cfg.lf_ana_opa = lf_opa; clear lf_ftp
        end
    end
    
else
    cfg.lf_ana_bst  = []; cfg.lf_ana_ftp = []; cfg.lf_ana_opa = []; cfg.lf_ana_opi = [];
    error('It seems that your model is not a sphere. Or cfg.sphereModel is not speficied in your cfg, please set it to 1 if you use sphere')
end
end