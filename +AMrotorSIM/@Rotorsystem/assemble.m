function assemble(obj)

% Adding rotor
for cnfg=obj.cnfg.cnfg_rotor
    obj.rotor = AMrotorSIM.Rotor.FEMRotor.FeModel(cnfg);
end

% Adding Sensors to Rotor
for cnfg=obj.cnfg.cnfg_sensor
    obj.sensors(end+1) = AMrotorSIM.Sensors.(cnfg.type)(cnfg);
end

% Adding Loads to System
for cnfg=obj.cnfg.cnfg_load
    obj.loads(end+1) = AMrotorSIM.Loads.(cnfg.type)(cnfg);
end

% Adding PID-Controller to System
for cnfg=obj.cnfg.cnfg_pid_controller
    obj.pidControllers(end+1) = AMrotorSIM.pidController(cnfg);
end

% Adding Components
for cnfg=obj.cnfg.cnfg_component
    if isfield(cnfg,'subtype')
        if ~isempty(cnfg.subtype)
            subtype = true;
        else
            subtype = false;
        end
    else
        subtype = false;
    end
    
    if subtype
        obj.components(end+1) = AMrotorSIM.Components.(cnfg.type).(cnfg.subtype)(cnfg);
    else
        obj.components(end+1) = AMrotorSIM.Components.(cnfg.type)(cnfg);
    end
    
end

% Adding automatic magnetic bearings
for cnfg=obj.cnfg.cnfg_automaticMagneticBearing
    obj.automaticMagneticBearings(end+1) = AMrotorSIM.automaticMagneticBearing(cnfg);
    obj.automaticMagneticBearings(end).assemble(obj); % add bearings and controllers to rotorsystem
end
    

end