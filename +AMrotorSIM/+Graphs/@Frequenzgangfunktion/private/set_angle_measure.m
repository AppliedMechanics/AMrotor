function angleMeasure = set_angle_measure(obj,userInputCell)
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