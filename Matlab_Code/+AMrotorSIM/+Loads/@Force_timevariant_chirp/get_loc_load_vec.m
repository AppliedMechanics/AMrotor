function get_loc_load_vec(obj,time,omega)

    obj.h = sparse(6,1);
   
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    fx = obj.cnfg.frequency_x;
    fy = obj.cnfg.frequency_y;
    fx0 = obj.cnfg.frequency_x_0;
    fy0 = obj.cnfg.frequency_y_0;
    t_end = obj.cnfg.t_end;
    
    obj.h(1) =  chirp(time,fx0,t_end,fx)*Fx;
    obj.h(2) =  chirp(time,fy0,t_end,fy)*Fy;
end