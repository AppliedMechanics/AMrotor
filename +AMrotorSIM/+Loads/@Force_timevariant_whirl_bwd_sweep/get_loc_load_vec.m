% Licensed under GPL-3.0-or-later, check attached LICENSE file

function h = get_loc_load_vec(obj,time,varargin)
% Assembles load vector for specific load type from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :parameter time: Time step
%    :type time: double
%    :parameter varargin: Placeholder
%    :type varargin: 
%    :return: Load vector h

    obj.h = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    f = obj.cnfg.frequency;
    f0 = obj.cnfg.frequency_0;
    tStart = obj.cnfg.t_start;
    tEnd = obj.cnfg.t_end;
    
    timeDelta = time - tStart;
    tEndDelta = tEnd - tStart;
    
    if (timeDelta >= 0 && time<tEnd)
        obj.h(1) =  chirp(timeDelta,f0,tEndDelta,f)*Fx;
        phaseInit = -90;
        obj.h(2) =  -chirp(timeDelta,f0,tEndDelta,f,'linear',phaseInit)*Fy;
    end
    h = obj.h;
end