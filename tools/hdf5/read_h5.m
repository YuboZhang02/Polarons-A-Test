function read_h5(fileName, varList)
% Read specified data from fileName.h5 file

fullFileName = [fileName, '.h5'];

% Get information about the HDF5 file
fileInfo = h5info(fullFileName);

% Check if there are datasets at the root level
if isfield(fileInfo, 'Datasets') && ~isempty(fileInfo.Datasets)
    datasetNames = {fileInfo.Datasets.Name};
else
    datasetNames = {};
end

% If varList is not provided, read all variables
if nargin < 2
    varList = datasetNames;
end

% Iterate through the specified variables
for i = 1:length(varList)
    varName = varList{i};
    readVariableFromH5(fullFileName, varName);
end

% Handle groups (potential structures)
for i = 1:length(fileInfo.Groups)
    groupName = fileInfo.Groups(i).Name(2:end); % Remove leading '/'
    structVar = struct();
    datasetNamesInGroup = {fileInfo.Groups(i).Datasets.Name};
    
    for j = 1:length(datasetNamesInGroup)
        datasetName = datasetNamesInGroup{j};
        fullVarName = [groupName, '/', datasetName];
        
        % Check for complex datasets within the group
        if endsWith(datasetName, '_real')
            baseName = extractBefore(datasetName, '_real');
            if ismember([baseName, '_imag'], datasetNamesInGroup)
                realPart = h5read(fullFileName, ['/', groupName, '/', baseName, '_real']);
                imagPart = h5read(fullFileName, ['/', groupName, '/', baseName, '_imag']);
                
                % Reconstruct the complex variable and assign to the structure
                structVar.(baseName) = complex(realPart, imagPart);
            end
        elseif ~endsWith(datasetName, '_imag') && ~ismember([datasetName, '_real'], datasetNamesInGroup) % Avoid reading the parts of complex variables again
            structVar.(datasetName) = readVariableFromH5(fullFileName, fullVarName);
        end
    end
    assignin('caller', groupName, structVar);
end



end

function varValue = readVariableFromH5(fullFileName, varName)
    % Initialize varValue to an empty array
    varValue = [];
    
    % Check if the specified variable exists in the HDF5 file
    if ~endsWith(varName, '_real') && ~endsWith(varName, '_imag')
        % Read the dataset directly
        varValue = h5read(fullFileName, ['/', varName]);

        % Convert uint16 back to char or string
        if isa(varValue, 'uint16')
            varValue = char(varValue);
        end

        % Convert double representation of logical back to logical
        if all(ismember(varValue, [0, 1]))
            varValue = logical(varValue);
        end
    end

    % Handle complex datasets
    if endsWith(varName, '_real')
        baseName = extractBefore(varName, '_real');
        if exist([fullFileName, '/', baseName, '_imag'], 'file')
            realPart = h5read(fullFileName, ['/', baseName, '_real']);
            imagPart = h5read(fullFileName, ['/', baseName, '_imag']);

            % Reconstruct the complex variable
            varValue = complex(realPart, imagPart);
        end
    end
end
