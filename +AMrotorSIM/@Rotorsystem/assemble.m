function assemble(obj)
% Imports the data (components) from the cnfg-file in the rotorsystem object
%
%    :parameter obj: rotorsystem object
%    :return: Filled out rotorsystem object

% Adding rotor
for cnfg=obj.cnfg.cnfg_rotor
    obj.rotor = AMrotorSIM.Rotor.FEMRotor.FeModel(cnfg);
end

% Adding Sensors to Rotor
for cnfg=obj.cnfg.cnfg_sensor
    obj.sensors(end+1) = AMrotorSIM.Sensors.(cnfg.type)(cnfg);
end
obj.get_sensor_mesh_position;

% Adding Loads to System
for cnfg=obj.cnfg.cnfg_load
    obj.loads(end+1) = AMrotorSIM.Loads.(cnfg.type)(cnfg);
end

% Adding PID-Controller to System
for cnfg=obj.cnfg.cnfg_pid_controller
    obj.pidControllers(end+1) = AMrotorSIM.pidControllers.(cnfg.type)(cnfg);
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

% Adding active magnetic bearings
for cnfg=obj.cnfg.cnfg_activeMagneticBearing
    obj.activeMagneticBearings(end+1) = AMrotorSIM.activeMagneticBearing(cnfg);
    obj.activeMagneticBearings(end).assemble(obj); % add bearings and controllers to rotorsystem
end
    

end