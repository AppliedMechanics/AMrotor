function assemble(obj)

% Adding rotor
for i=obj.cnfg.cnfg_rotor
    obj.rotor = AMrotorSIM.Rotor.FEMRotor.FeModel(i);
end

% Adding Sensors to Rotor
for i=obj.cnfg.cnfg_sensor
    obj.sensors(end+1) = AMrotorSIM.Sensors.(i.type)(i);
end

% Adding Loads to System
for i=obj.cnfg.cnfg_load
    obj.loads(end+1) = AMrotorSIM.Loads.(i.type)(i);
end

% Adding Seals to System
for i=obj.cnfg.cnfg_seal
    obj.seals(end+1) = AMrotorSIM.Seals.(i.type)(i);
end

% Adding Components
for i=obj.cnfg.cnfg_component
    if isfield(i,'subtype')
        if ~isempty(i.subtype)
            subtype = true;
        else
            subtype = false;
        end
    else
        subtype = false;
    end
    
    if subtype
        obj.components(end+1) = AMrotorSIM.Components.(i.type).(i.subtype)(i);
    else
        obj.components(end+1) = AMrotorSIM.Components.(i.type)(i);
    end
    
end
end