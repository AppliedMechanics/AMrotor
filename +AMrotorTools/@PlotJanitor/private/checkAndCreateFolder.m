function checkAndCreateFolder(folderPath)  
%CHECKANDCREATEFOLDER Summary of this function goes here
%   Detailed explanation goes here
if ~exist(folderPath,'dir')
    mkdir(folderPath);
end

end

