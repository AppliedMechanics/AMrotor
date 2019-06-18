function get_loc_load_vec(obj,time,varargin)

    obj.h = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    f = obj.cnfg.frequency;
    
    obj.h(1) =  cos(2*pi*f*time)*Fx;
    obj.h(2) =  -sin(2*pi*f*time)*Fy;
    
end
