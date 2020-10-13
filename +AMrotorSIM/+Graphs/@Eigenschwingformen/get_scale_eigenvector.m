% Licensed under GPL-3.0-or-later, check attached LICENSE file

function scaleEigenvector = get_scale_eigenvector(obj,userInputCell)
% Extracts the eventually included scale factor in the argument for the 3D visualization of the mode shapes
%
%    :param userInputCell: Cell that gets checked if 'scale' command and corresponding value is included 
%    :type userInputCell: cell
%    :return: Scale factor


str{1} = 'scale';
str{2} = 'sc';
isAll = false;

%pre-allocate so that every node gets plotted 
scaleEigenvector = 1;

i = 1;
userInputIndex = 0;
while i <= length(str) && ~any(userInputIndex) %&& ~isAll
    userInputIndex = find(strcmpi(userInputCell,str{i}));
    i = i+1;
end

if any(userInputIndex)
    % if user wishes to plot all the nodes by specifying 'all' -> step out
    if ischar(userInputCell{userInputIndex+1})
        if any(strcmpi(userInputCell(userInputIndex+1),{'all','a'}))
            isAll = true;
        end
    end

    if ~isAll
        scaleEigenvector = cell2mat(userInputCell(userInputIndex+1));
    end
end

end