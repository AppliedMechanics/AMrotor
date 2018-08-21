function dZ = integrate_function(t,Z, ss_A,ss_B,ss_h,n_nodes,omega_rot_const_force,rotorsystem)

%% init Vector

phi=zeros(12*n_nodes,1);
omega=zeros(12*n_nodes,1);

for node = 1:n_nodes
    dof_x = rotorsystem.rotor.get_gdof('u_x',node);
    dof_psi_z = rotorsystem.rotor.get_gdof('psi_z',node);
    phi(dof_x:dof_x+1)=Z(dof_psi_z);
    omega(dof_x:dof_x+1)=Z(6*n_nodes+dof_psi_z);
end

domega=0;

% Zeit ausgeben
t

h_ges = (ss_h.h +(ss_h.h_ZPsin.*(omega.^2) + ss_h.h_DBsin.*domega +ss_h.h_sin).*(-1).*sin(phi) ...
             +(ss_h.h_ZPcos.*(omega.^2) + ss_h.h_DBcos.*domega +ss_h.h_cos).*(-1).*cos(phi)) ...
             + ss_h.h_rotsin.*sin(phi*omega_rot_const_force) + ss_h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

%% DGL

dZ = -ss_A\ss_B*Z+ss_A\h_ges;
end

