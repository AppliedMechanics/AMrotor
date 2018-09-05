function assemble(obj)

   % Adding rotor
    for i=obj.cnfg.cnfg_rotor
    obj.add_FEMRotor(i);
    end

   % Adding discs
    for i=obj.cnfg.cnfg_disc
    obj.add_Disc(i);
    end

    % Adding Sensors to Rotor
    for i=obj.cnfg.cnfg_sensor
    obj.add_Sensor(i);
    end

    % Adding Lager to Rotor
    for i=obj.cnfg.cnfg_bearing
    obj.add_Bearing(i);
    end

    % Adding Loads to System
    for i=obj.cnfg.cnfg_load
        obj.add_Load(i);
    end
end