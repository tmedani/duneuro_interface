function findAndMoveDepencencies(file, destination)
% find and find all the function or script file uses and then create and
% move all these file to destination.

% file : matlab script or function
% destination : directory where to copy the dependencies

% Takfarinas MEDANI


fList = matlab.codetools.requiredFilesAndProducts(file);

for ind = 1 : length(fList)
disp(['Copying "' fList{ind} '" to "' destination '"'])
    copyfile(fList{ind},destination,'f')
end

end