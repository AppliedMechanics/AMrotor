function [M_s,D_s,K_s] = get_loc_system_matrices(self,node)
% dof-order: ux,uy,uz,psix,psiy,psiz

u = node.q(1:2);
ud = node.qd(1:2);
omega = node.qd(6);
if omega == 0 %Model does not work for rpm=0 because of a division by rpm
    omega =0.1;
end

% dof-order: ux,uy,uz,psix,psiy,psiz

sys = self.cnfg.sealModel.sys;

% Zustand 0 InnerRing
init.omega0IR = [omega;0;0];       % Einheit: rad/s !

% from CW StandaloneMuszynskaEcc.m
sys.gamma0 = 0.4;%0.4; %ratio of fluid circumferential average velocity: gamma0 < 0.5
sys.alpha=0;

% Eccentricity
sys.ecc = sqrt(u(1)^2+u(2)^2)/sys.S; %sys.S=Spaltweite, 0<sys.ecc<1
% ecc = sys.ecc

[ Koeff ] = self.MuszynskaModelNewLaminar( sys,init );

K_s = [Koeff.K_xx, Koeff.k_xy; -Koeff.k_xy, Koeff.K_xx];
D_s = [Koeff.C_xx, Koeff.c_xy; -Koeff.c_xy, Koeff.C_xx];
M_s = [Koeff.M_xx, 0; 0, Koeff.M_xx];

self.mass_matrix = zeros(6);
self.damping_matrix = zeros(6);
self.stiffness_matrix = zeros(6);
self.mass_matrix(1:2,1:2) = M_s;
self.damping_matrix(1:2,1:2) = D_s;
self.stiffness_matrix(1:2,1:2) = K_s;

end