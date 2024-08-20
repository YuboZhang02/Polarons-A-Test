function save_h5(fileName)
% save all the data to fileName.h5 file

fullFileName = [fileName, '.h5'];

% Check if the file exists, if it does, delete it
if exist(fullFileName, 'file')
    delete(fullFileName);
end

% Get all variables from the workspace
workspaceVars = evalin('caller', 'who');

% List of variables that should have the third dimension set to expandable
expandableVars = {'alltime_psi', 'alltime_U', 'psi_bs', 'psip_bs'}; % Add your variable names here

% Compression level
compressionLevel = 5; % You can change this value as needed

% Iterate through all workspace variables and store them in the HDF5 file
for i = 1:length(workspaceVars)
    varName = workspaceVars{i};
    varValue = evalin('caller', varName);
    
    % Handle structures
    if isstruct(varValue)
        fields = fieldnames(varValue);
        for j = 1:numel(fields)
            fieldName = fields{j};
            fieldValue = varValue.(fieldName);
            saveVariableToH5(fullFileName, [varName, '/', fieldName], fieldValue, expandableVars, compressionLevel);
        end
    else
        saveVariableToH5(fullFileName, varName, varValue, expandableVars, compressionLevel);
    end
end

end

function saveVariableToH5(fullFileName, varName, varValue, expandableVars, compressionLevel)
    % Only store specified types of data
    if ~(isnumeric(varValue) || islogical(varValue) || ischar(varValue))
        return;
    end
    
    % Convert logical to double
    if islogical(varValue)
        varValue = double(varValue);
    end
    
    % Special handling for char arrays and strings
    if ischar(varValue) || isstring(varValue)
        varValue = uint16(char(varValue)); % Convert to uint16
    end
    
    % Special handling for complex double arrays
    if isnumeric(varValue) && ~isreal(varValue)
        realPart = real(varValue);
        imagPart = imag(varValue);
        
        % Store real and imaginary parts separately
        h5create(fullFileName, ['/', varName, '_real'], size(realPart), 'Datatype', 'double');
        h5write(fullFileName, ['/', varName, '_real'], realPart);
        
        h5create(fullFileName, ['/', varName, '_imag'], size(imagPart), 'Datatype', 'double');
        h5write(fullFileName, ['/', varName, '_imag'], imagPart);
    else
        % Check if the variable is a three-dimensional matrix and is in the expandableVars list
        if ndims(varValue) == 3 && ismember(varName, expandableVars)
            % Set the third dimension to be expandable using ChunkSize
            dims = size(varValue);
            chunkDims = [dims(1), dims(2), 1];
            h5create(fullFileName, ['/', varName], dims, 'ChunkSize', chunkDims, 'Datatype', class(varValue), 'Deflate', compressionLevel);
            h5write(fullFileName, ['/', varName], varValue);
        else
            % Store other variables directly
            h5create(fullFileName, ['/', varName], size(varValue), 'Datatype', class(varValue));
            h5write(fullFileName, ['/', varName], varValue);
        end
    end
end
