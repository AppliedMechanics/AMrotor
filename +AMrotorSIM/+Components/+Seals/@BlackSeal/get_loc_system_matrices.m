% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [M,D,K] = get_loc_system_matrices(self,rpm)
% Provides/builds all three matrices (M, D, K) of the seal in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Rotation speed
%    :type rpm: double
%    :return: M-, D-, K-matrices

M = sparse(6,6);
D = sparse(6,6);
K = sparse(6,6);

sys = self.cnfg.sealModel.sys;

% Zustand 0 AR  Initialisierung
init.x0AR = [0;0;0];
init.phi0AR = [0;0;0];
init.xd0AR = [0;0;0];
init.omega0AR = [0;0;0];
% Zustand 0 IR
init.x0IR = [0;0.0;0];
init.phi0IR = [0;0;0];
init.xd0IR = [0;0;0];
init.omega0IR = [rpm*pi/30;0;0];       % Einheit: rad/s !

[ M_s,D_s,K_s ] = self.BlackModel( sys, init );


 M(1:2,1:2) = M_s;
 D(1:2,1:2) = D_s;
 K(1:2,1:2) = K_s;

end