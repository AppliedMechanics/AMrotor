function get_loc_load_vec(obj,~,omega,U_node)
% U_node = [u_x; u_y; u_z; psi_x; psi_y; psi_z; du_x; du_y; du_z; dpsi_x; dpsi_y; dpsi_z] 
    par = obj.cnfg.par;
    par.omega = omega;
    phi0=U_node(6); 
    par.phi=[0:(2*pi/par.N):(2*pi/par.N)*(par.N-1)]+phi0; %par.N=numberOfBalls
        
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    U_node(3) = 1.8e-4; % "Lagervorspannung" damit glattes Problem fuer Zeitintegration -> kein Bereich mit F=0 um u_x,u_y=0  herum
    obj.h = -obj.LimSinghForce(par,U_node);
    obj.h(3) = 0;
    
end