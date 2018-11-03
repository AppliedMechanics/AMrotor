function assemble(obj)

   % Adding rotor
    for i=obj.cnfg.cnfg_rotor
    obj.rotor = AMrotorSIM.Rotor.FEMRotor.FeModel(i); 
    end

   % Adding discs
    for i=obj.cnfg.cnfg_disc
    obj.discs = AMrotorSIM.Disc(i);
    end

    % Adding Sensors to Rotor
    for i=obj.cnfg.cnfg_sensor
    obj.sensors(end+1) = AMrotorSIM.Sensors.(i.type)(i);
    end

    % Adding Lager to Rotor
    for i=obj.cnfg.cnfg_bearing
    obj.bearings(end+1) = AMrotorSIM.Bearings.(i.type)(i);
    end

    % Adding Loads to System
    for i=obj.cnfg.cnfg_load
    obj.loads(end+1) = AMrotorSIM.Loads.(i.type)(i);
    end
    % Adding Seals to System
    for i=obj.cnfg.cnfg_seal
    obj.seals(end+1) = AMrotorSIM.Seals.(i.type)(i);
    end
end