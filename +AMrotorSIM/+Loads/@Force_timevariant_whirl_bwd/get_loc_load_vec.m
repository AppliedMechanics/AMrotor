% Licensed under GPL-3.0-or-later, check attached LICENSE file

function h = get_loc_load_vec(obj,time,varargin)
% Assembles load vector for specific load type from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :parameter time: Time step
%    :type time: double
%    :parameter varargin: not defined?????
%    :type varargin: 
%    :return: Load vector h

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
    obj.h(2) =  -sin(2*pi*f*timeDelta)*Fy;
    end
    h = obj.h;
end
