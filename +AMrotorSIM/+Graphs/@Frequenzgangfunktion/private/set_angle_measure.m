function angleMeasure = set_angle_measure(obj,userInputCell)
% Extracts the desired angle representation from the argument of the main function
%
%    :param userInputCell: Cell that gets checked which representation type ('rad' (default) or 'deg') is wanted
%    :type userInputCell: cell
%    :return: Angle representation type as char

% Licensed under GPL-3.0-or-later, check attached LICENSE file

radStr = 'rad';
degStr = 'deg';

radBool = false;
degBool = false;

if any(strcmpi(userInputCell,degStr))
    degBool = true;
end
if any(strcmpi(userInputCell,radStr))
    radBool = true;
end
if radBool && degBool
    error(['Select ''rad'' or ''deg'' for the measure of the '...
        'phase in the visualisation of the frequency response function'])
elseif degBool
    angleMeasure = 'deg';
else
    angleMeasure = 'rad'; % default
end
end