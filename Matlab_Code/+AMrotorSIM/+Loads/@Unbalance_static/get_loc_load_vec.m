function get_loc_load_vec(obj,time,node,varargin)

%Constant fix force 
    obj.h = sparse(6,1);    
    % dof-order: ux,uy,uz,psix,psiy,psiz

    %%
    unwucht = obj.cnfg.betrag;
    phase = obj.cnfg.winkellage;
    omega = node.omega;

    obj.h(1) = unwucht * omega^2 * cos(omega*time + phase);
    obj.h(2) = unwucht * omega^2 * sin(omega*time + phase);
    
    % Achtung: Hier wird der Anteil der Drehbeschleunigung vernachlässigt
    % und nur der Anteil aus der Zentripetalkraft berücksichtigt. Die
    % Drehbeschleunigung domega verursacht sowohl Kraefte als auch ein
    % Drehmoment.
end