function addallpath()
    % Function to add the current directory and all its subdirectories to the MATLAB path

    % Call the recursive function for the current directory
    addAllSubfoldersToPath(pwd);
end

function addAllSubfoldersToPath(baseFolder)
    % Recursive function to add the base folder and all its subfolders to the path

    % Add the base folder to the path
    addpath(baseFolder);
    
    % Get all items in the base folder
    d = dir(baseFolder);
    
    % Filter to get only directories
    subfolders = {d([d.isdir]).name};
    
    % Exclude the '.' and '..' special directories
    subfolders = subfolders(~ismember(subfolders, {'.', '..'}));
    
    % Recursively add each subfolder to the path
    for i = 1:length(subfolders)
        addAllSubfoldersToPath(fullfile(baseFolder, subfolders{i}));
    end
end
