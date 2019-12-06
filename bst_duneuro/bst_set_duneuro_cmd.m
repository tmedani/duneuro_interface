function cfg = bst_set_duneuro_cmd(cfg)
% Select the command line acording to the version of the cfg.BstDuneuroVersion
% cfg.BstDuneuroVersion = 1 : refers to the previous app generated before the combined version
% cfg.BstDuneuroVersion = 2 : refers to the new app generated by the new version of Juan.
% Author : Takfarinas MEDANI, November, 2019,

if ~isfield(cfg,'BstDuneuroVersion');  cfg.BstDuneuroVersion = 1; end

if cfg.BstDuneuroVersion == 1
    if strcmp(cfg.modality,'eeg')
        if cfg.useTransferMatrix  == 1 % faster
            cmd = 'bst_eeg_transfer';
        else
            cmd = 'bst_eeg_forward';     % not recommended
        end
    elseif strcmp(cfg.modality,'meg')
        % other modalities meg, ieeg, seeg ...
        % TODO
    elseif strcmp(cfg.modality,'seeg')
        % other modalities meg, ieeg, seeg ...
        % TODO
    elseif strcmp(cfg.modality,'ieeg')
        % other modalities meg, ieeg, seeg ...
        % TODO
    elseif strcmp(cfg.modality,'ecog')
        % other modalities meg, ieeg, seeg ...
        % TODO
    end
end

if cfg.BstDuneuroVersion == 2 % refers to the new version
    cmd = 'bst_duneuro';
end

cfg.cmd = cmd;
end