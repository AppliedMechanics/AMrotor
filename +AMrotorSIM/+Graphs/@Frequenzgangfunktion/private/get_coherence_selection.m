function flagCoh = get_coherence_selection(obj,userInputCell)
% Checks if coherence is in the argument of the main function
%
%    :param userInputCell: Cell that gets checked if coherence is desired ('coh')
%    :type userInputCell: cell
%    :return: Flag if coherence is desired or not

% Licensed under GPL-3.0-or-later, check attached LICENSE file

str = {'coh','coherence'};
flagCoh = false;

if any(strcmpi(userInputCell,str{1}))
    flagCoh = true;
end

if any(strcmpi(userInputCell,str{2}))
    flagCoh = true;
end

% does coherence exist
if ~isprop(obj.experimentFRF,'C') && flagCoh
    flagCoh = false;
    warning('coherence does not exist')
end

end