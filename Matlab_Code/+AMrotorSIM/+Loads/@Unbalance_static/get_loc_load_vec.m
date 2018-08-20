function get_loc_load_vec(obj)

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
    unwucht = obj.cnfg.betrag;
    phase = obj.cnfg.winkellage;

    obj.h.h_ZPcos(1) =  unwucht*cos(phase);
    obj.h.h_ZPcos(2) =  unwucht*sin(phase);
    obj.h.h_ZPsin(1) =  - unwucht*sin(phase);
    obj.h.h_ZPsin(2) =  unwucht*cos(phase);

    obj.h.h_DBcos(1) =  unwucht*sin(phase);
    obj.h.h_DBcos(2) = - unwucht*cos(phase);
    obj.h.h_DBsin(1) =  unwucht*cos(phase);
    obj.h.h_DBsin(2) =  unwucht*sin(phase); 
end