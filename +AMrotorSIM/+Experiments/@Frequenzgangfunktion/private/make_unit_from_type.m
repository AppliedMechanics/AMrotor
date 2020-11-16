function unitStr = make_unit_from_type(obj)
% Assigns the correct unit depending of the FRF type
%
%    :return: Added unit parameter to the object

% Licensed under GPL-3.0-or-later, check attached LICENSE file

% unit aus container
    unitStrContainer = {'\frac{m}{N}','\frac{m}{Ns}','\frac{m}{Ns^2}'};
    types = {'d','v','a'};
    unitContainer = containers.Map(types,unitStrContainer);
    unitStr = unitContainer(obj.type);
    
    obj.unit = unitStr;
end