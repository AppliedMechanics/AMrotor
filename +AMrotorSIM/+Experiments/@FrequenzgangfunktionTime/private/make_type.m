function type = make_type(obj)
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