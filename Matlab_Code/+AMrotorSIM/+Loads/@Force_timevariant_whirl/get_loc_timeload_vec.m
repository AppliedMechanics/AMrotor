function get_loc_timeload_vec(obj,t)

%Constant fix force 
    obj.h.h = sparse(6,1);

    %centripetal-force unbalance, rotating
    obj.h.h_ZPcos = sparse(6,1);
    obj.h.h_ZPsin = sparse(6,1);

    %unbalance mass inertia force 
    obj.h.h_DBcos = sparse(6,1);
    obj.h.h_DBsin = sparse(6,1);

    %Constant_fix_force in rotor coordinates!
    obj.h.h_sin = sparse(6,1);                     
    obj.h.h_cos = sparse(6,1);

    %rotating_fix_force%   e.g  bearing exitation 
    obj.h.h_rotsin = sparse(6,1);                 
    obj.h.h_rotcos = sparse(6,1);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz

    %%
    Fx = obj.cnfg.betrag_x;
    Fy = obj.cnfg.betrag_y;
    f = obj.cnfg.frequency;
    
    obj.h.h(1) =  cos(2*pi*f*t)*Fx;
    obj.h.h(2) =  sin(2*pi*f*t)*Fy;
end