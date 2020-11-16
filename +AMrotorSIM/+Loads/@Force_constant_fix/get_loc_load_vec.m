function h = get_loc_load_vec(obj,varargin)
% Assemles load vector for specific load type from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :parameter varargin: Placeholder
%    :type varargin: 
%    :return: Load vector h

% Licensed under GPL-3.0-or-later, check attached LICENSE file
            
%Constant fix force 
    obj.h = sparse(6,1);

    % dof-order: ux,uy,uz,psix,psiy,psiz

    %%
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;

    obj.h(1) =  Fx;
    obj.h(2) =  Fy;
    
    h = obj.h;
end