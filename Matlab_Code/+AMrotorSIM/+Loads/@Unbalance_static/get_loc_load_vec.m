function get_loc_load_vec(obj,time,node,varargin)

    %Constant fix force 
    obj.h = sparse(6,1);    
    % dof-order: ux,uy,uz,psix,psiy,psiz

    %%
    unwucht = obj.cnfg.betrag;
    phase = obj.cnfg.winkellage;
    omega = node.qd(6);
    omegadot = node.qdd(6);
    
    % Anteil aufgrund Zentripetalkraft
    F_ZP(1) = unwucht * omega^2 * cos(omega*time + phase);
    F_ZP(2) = unwucht * omega^2 * sin(omega*time + phase);
    
    % Anteil aufgrund der Drehbeschleunigung:
    F_DB(1) = + unwucht * omegadot * sin(omega*time + phase);
    F_DB(2) = - unwucht * omegadot * cos(omega*time + phase);
    
    % Zusammenstellen
    obj.h(1) = F_ZP(1) + F_DB(1);
    obj.h(2) = F_ZP(2) + F_DB(2);
    
    % evtl. weitere Schritte: Drehmoment aufgrund F_DB hinzufuegen
    
    
end