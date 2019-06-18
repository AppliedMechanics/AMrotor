function [ss_h]= compute_system_load(self,t, Z)

h = self.systemmatrices.h;

n_nodes = length(self.rotor.mesh.nodes);

phi=zeros(6*n_nodes,1);
omega=zeros(6*n_nodes,1);

for node = 1:n_nodes
    dof_u_x = self.rotor.get_gdof('u_x',node);
    dof_psi_z = self.rotor.get_gdof('psi_z',node);
    phi(dof_u_x:dof_psi_z)=Z(dof_psi_z);
    omega(dof_u_x:dof_psi_z)=Z(end/2+dof_psi_z);
end

domega=0;
omega_rot_const_force=0; %[1/s] angular velocity of constant_rotating_force 

h_ges = (h.h +(h.h_ZPsin.*(omega.^2) + h.h_DBsin.*domega +h.h_sin).*(-1).*sin(phi) ...
             +(h.h_ZPcos.*(omega.^2) + h.h_DBcos.*domega +h.h_cos).*(-1).*cos(phi)) ...
             + h.h_rotsin.*sin(phi*omega_rot_const_force) + h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

ss_h=[h_ges;zeros(length(h_ges),1)];
         
end