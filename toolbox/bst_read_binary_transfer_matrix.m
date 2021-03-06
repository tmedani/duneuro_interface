function cfg = bst_read_binary_transfer_matrix(cfg)
% bst_read_binary_transfer_matrix(filename)
% read the binary output from the duneuro application.
% could be used to read either the eeg/meg transfer matrix or the eeg/meg
% leadfield mtrix.
% usage :

% binary outpuf from duneuro :
% 'eeg_transfer.dat'
% 'meg_transfer.dat'
% 'meg_lf.dat'
% 'eeg_lf.dat'

currentPath = pwd;

if isfield(cfg,'pathOfTempOutPut')
    cd(cfg.pathOfTempOutPut )
else
    error('Please specify the output path on the cfg structure as a string under cfg.pathOfTempOutPut ')
end

% eeg
if strcmp(cfg.modality,'eeg')
    inFile = 'eeg_transfer.dat';
    mat=read_duneuro_binary_file(inFile);
    cfg.duneuro_eeg_transfer = mat;
end

%meg
if strcmp(cfg.modality,'meg')
    inFile = 'meg_transfer.dat';
    mat=read_duneuro_binary_file(inFile);
    cfg.duneuro_meg_transfer = mat;
end

% to be completed with other modalities seeg, ieeg ...

cd(currentPath)

end
