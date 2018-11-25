function get_loc_load_vec(obj,time,varargin)

    obj.h = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    f = obj.cnfg.frequency;
    f0 = obj.cnfg.frequency_0;
    t_end = obj.cnfg.t_end;
    
    obj.h(1) =  chirp(time,f0,t_end,f)*Fx;
    phaseInit = -90;
    obj.h(2) =  chirp(time,f0,t_end,f,'linear',phaseInit)*Fy;
end