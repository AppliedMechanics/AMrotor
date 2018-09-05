function [h_ges]= compute_system_load(self,t, phi, omega, domega)

ss_h = self.systemmatrices.ss_h;
omega_rot_const_force=0; %[1/s] angular velocity of constant_rotating_force 

h_ges = (ss_h.h +(ss_h.h_ZPsin.*(omega.^2) + ss_h.h_DBsin.*domega +ss_h.h_sin).*(-1).*sin(phi) ...
             +(ss_h.h_ZPcos.*(omega.^2) + ss_h.h_DBcos.*domega +ss_h.h_cos).*(-1).*cos(phi)) ...
             + ss_h.h_rotsin.*sin(phi*omega_rot_const_force) + ss_h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

end