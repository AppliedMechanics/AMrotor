function numberOfTangentialPoints = get_number_of_tangential_points(obj,userInputCell)
% numberOfTangentialPoints = get_number_of_tangential_points(obj,userInputCell)

str{1} = 'radialpoints';
str{2} = 'radial';
str{3} = 'rad';
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