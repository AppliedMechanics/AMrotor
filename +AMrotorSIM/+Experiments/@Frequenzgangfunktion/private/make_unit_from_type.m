function unitStr = make_unit_from_type(obj)

% unit aus container
    unitStrContainer = {'\frac{m}{N}','\frac{m}{Ns}','\frac{m}{Ns^2}'};
    types = {'d','v','a'};
    unitContainer = containers.Map(types,unitStrContainer);
    unitStr = unitContainer(obj.type);
    
    obj.unit = unitStr;
end