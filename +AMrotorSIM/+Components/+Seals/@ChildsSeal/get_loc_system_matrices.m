function [M,D,K] = get_loc_system_matrices(self,rpm)
% dof-order: ux,uy,uz,psix,psiy,psiz

M = sparse(6,6);
D = sparse(6,6);
K = sparse(6,6);

if rpm == 0 %ChildsModel does not work for rpm=0 because of a division by rpm
    rpm=1;
end

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

[ M_s,D_s,K_s ] = self.ChildsModel( sys, init );


M(1:2,1:2) = M_s;
D(1:2,1:2) = D_s;
K(1:2,1:2) = K_s;


end