function get_loc_load_vec(obj,~,omega,U_node)
% U_node = [u_x; u_y; u_z; psi_x; psi_y; psi_z; du_x; du_y; du_z; dpsi_x; dpsi_y; dpsi_z] 
    par = obj.cnfg.par;
    par.omega = omega;
    phi0=U_node(6); 
    par.phi=[0:(2*pi/par.N):(2*pi/par.N)*(par.N-1)]+phi0; %par.N=numberOfBalls
        
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    obj.h = -obj.LimSinghForce(par,U_node(1:5)); % Mit dem Minus hängt es zumindest nicht, Mit Plus gubt es Probleme
    obj.h(3) = 0;
    
end