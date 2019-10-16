function flagCoh = get_coherence_selection(obj,userInputCell)
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