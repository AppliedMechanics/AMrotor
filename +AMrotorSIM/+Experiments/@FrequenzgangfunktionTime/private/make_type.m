% Licensed under GPL-3.0-or-later, check attached LICENSE file

function type = make_type(obj)
% Converts full output type of FRF in abbrevation (e.g.: 'Distance'->'d')
%
%    :return: Added type parameter to the object

typeIn = obj.sensorIn.measurementType;
typeOut = obj.sensorOut.measurementType;

type = '';
if strcmp(typeIn,'Force')
    switch typeOut
        case 'Distance'
            type = 'd';
        case 'Velocity'
            type = 'v';
        case 'Acceleration'
            type = 'a';
        otherwise
    end

end

obj.type = type;

end