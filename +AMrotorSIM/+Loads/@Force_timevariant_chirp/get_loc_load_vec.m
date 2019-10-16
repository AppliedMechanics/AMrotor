function h = get_loc_load_vec(obj,time,varargin)

    obj.h = sparse(6,1);
   
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    fx = obj.cnfg.frequency_x;
    fy = obj.cnfg.frequency_y;
    fx0 = obj.cnfg.frequency_x_0;
    fy0 = obj.cnfg.frequency_y_0;
    tStart = obj.cnfg.t_start;
    tEnd = obj.cnfg.t_end;
    
    timeDelta = time - tStart;
    tEndDelta = tEnd - tStart;
    
    if (timeDelta > 0 && time<tEnd)
        obj.h(1) =  chirp(time,fx0,tEndDelta,fx)*Fx;
        obj.h(2) =  chirp(time,fy0,tEnd,fy)*Fy;
    end
    
    h = obj.h;
end