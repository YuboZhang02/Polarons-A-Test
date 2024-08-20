function outputStruct = read_input(fileName)
%READ_INPUT read and evaluate each line in the input txt file and store all workspace variables in a structure

% Add .txt extension to the file name
fileNameTxt = strcat(fileName, '.txt');

% Open the file with read permission
fileID = fopen(fileNameTxt, 'r');

% Check if file exists
if fileID == -1
    error('File not found');
end

% Read the file line by line
nextLine = fgetl(fileID);
while ischar(nextLine)
    eval(nextLine); % Evaluate the current line
    nextLine = fgetl(fileID); % Read the next line
end

% Close the file
fclose(fileID);

clear ans
clear fileID
clear fileNameTxt
clear nextLine

% Store all workspace variables in a structure
varNames = who;
outputStruct = struct();

for i = 1:length(varNames)
    outputStruct.(varNames{i}) = eval(varNames{i});
end

end
