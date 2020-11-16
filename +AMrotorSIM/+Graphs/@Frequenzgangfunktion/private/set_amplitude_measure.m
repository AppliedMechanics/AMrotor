function amplitudeMeasure = set_amplitude_measure(obj,userInputCell)
% Extracts the desired amplitude representation from the argument of the main function
%
%    :param userInputCell: Cell that gets checked which representation type ('lin' (default),'log' or 'dB') is wanted
%    :type userInputCell: cell
%    :return: Amplitude representation type as char

% Licensed under GPL-3.0-or-later, check attached LICENSE file

linStr = 'lin';
logStr = 'log';
dbStr = 'dB';
linBool = false;
logBool = false;
dbBool = false;

if any(strcmpi(userInputCell,linStr))
    linBool = true;
end
if any(strcmpi(userInputCell,logStr))
    logBool = true;
end
if any(strcmpi(userInputCell,dbStr))
    dbBool = true;
end

if nnz([linBool,logBool,dbBool]) > 1 % mehr als 1 true
    error(['Select ''lin'', ''log'' or ''dB'' for the measure of the '...
        'amplitude in the visualisation of the frequency response function'])
elseif logBool
    amplitudeMeasure = logStr;
elseif dbBool
    amplitudeMeasure = dbStr;
else
    amplitudeMeasure = linStr; %default
end
end