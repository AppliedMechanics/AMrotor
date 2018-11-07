function moduloOfNodesToPlot = get_modulo_of_nodes_to_plot(obj,userInputCell)
% moduloOfNodesToPlot = determine_modulo_of_nodes_to_plot(obj,userInputCell)
% for example: 
%   moduloOfNodesToPlot = 1 -> plot circle at every node
%   moduloOfNodesToPlot = 2 -> plot circle at every second node
%   ...
%   moduloOfNodesToPlot = 10 -> plot circle at every tenth node

str{1} = 'SkipNodes';
str{2} = 'skip';
str{3} = 's';
isAll = false;

%pre-allocate so that every node gets plotted 
moduloOfNodesToPlot = 1;

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
        moduloOfNodesToPlot = cell2mat(userInputCell(userInputIndex+1));
    end
end

end