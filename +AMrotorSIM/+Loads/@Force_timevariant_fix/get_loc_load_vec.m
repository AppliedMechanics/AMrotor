% Licensed under GPL-3.0-or-later, check attached LICENSE file

function h = get_loc_load_vec(obj,time,varargin)
% Assemles load vector for specific load type from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
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
    fx = obj.cnfg.frequency_x;
    fy = obj.cnfg.frequency_y;
    
    obj.h(1) =  sin(2*pi*fx*time)*Fx;
    obj.h(2) =  sin(2*pi*fy*time)*Fy;
    
    h = obj.h;
end