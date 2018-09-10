function [ss_h]= compute_system_load_variant(self,t, phi, omega, domega)

h = self.systemmatrices.h;
omega_rot_const_force=0; %[1/s] angular velocity of constant_rotating_force 

h_ges = (h.h +(h.h_ZPsin.*(omega.^2) + h.h_DBsin.*domega +h.h_sin).*(-1).*sin(phi) ...
             +(h.h_ZPcos.*(omega.^2) + h.h_DBcos.*domega +h.h_cos).*(-1).*cos(phi)) ...
             + h.h_rotsin.*sin(phi*omega_rot_const_force) + h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

ss_h=[zeros(length(h_ges),1);h_ges];
         
end