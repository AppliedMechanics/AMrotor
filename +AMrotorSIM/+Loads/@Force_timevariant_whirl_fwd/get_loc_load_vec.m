function h = get_loc_load_vec(obj,time,varargin)

    obj.h = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    f = obj.cnfg.frequency;
    tStart = obj.cnfg.t_start;
    tEnd = obj.cnfg.t_end;
    
    timeDelta = time - tStart;
    
    if (timeDelta >= 0 && time<tEnd)
    obj.h(1) =  cos(2*pi*f*timeDelta)*Fx;
    obj.h(2) =  sin(2*pi*f*timeDelta)*Fy;
    end
    h = obj.h;
end
