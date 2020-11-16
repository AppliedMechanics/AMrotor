function unit = make_unit(obj)
% Assigns the correct unit depending on the used sensor types (in- and output)
%
%    :return: Added unit parameter to the object

% Licensed under GPL-3.0-or-later, check attached LICENSE file

sensorIn = obj.sensorIn;
sensorOut = obj.sensorOut;

unit = ['\frac{',sensorOut.unit,'}{',sensorIn.unit,'}'];
obj.unit = unit;

end