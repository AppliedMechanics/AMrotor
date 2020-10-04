% Licensed under GPL-3.0-or-later, check attached LICENSE file

function numberOfTangentialPoints = get_number_of_tangential_points(obj,userInputCell)
% Extracts the eventually included 'tangentialPoints' command in the argument for the 3D visualization of the mode shapes
%
%    :param userInputCell: Cell that gets checked if 'tangentialPoints' command and corresponding value is included
%    :type userInputCell: cell
%    :return: Number of tangential points for circles for visualization of the mode shapes

% numberOfTangentialPoints = get_number_of_tangential_points(obj,userInputCell)

str{1} = 'tangentialpoints';
str{2} = 'tangential';
str{3} = 'tang';
isAll = false;

%pre-allocate
numberOfTangentialPoints = 20;

i = 1;
userInputIndex = 0;
while i <= length(str) && ~any(userInputIndex)
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
        numberOfTangentialPoints = cell2mat(userInputCell(userInputIndex+1));
    end
end

end