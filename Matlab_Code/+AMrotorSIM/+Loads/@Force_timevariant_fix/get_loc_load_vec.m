function get_loc_load_vec(obj,time,varargin)

    obj.h = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    fx = obj.cnfg.frequency_x;
    fy = obj.cnfg.frequency_y;
    
    obj.h(1) =  sin(2*pi*fx*time)*Fx;
    obj.h(2) =  sin(2*pi*fy*time)*Fy;
end