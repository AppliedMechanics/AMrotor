function get_loc_load_vec(self,~,node)

u = node.q(1:2);
ud = node.qd(1:2);
udd = node.qdd(1:2);
omega = node.qd(6);

% dof-order: ux,uy,uz,psix,psiy,psiz

if omega == 0 %ChildsModel does not work for rpm=0 because of a division by rpm
    omega =0.1;
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
init.omega0IR = [omega;0;0];       % Einheit: rad/s !

[ M_s,D_s,K_s ] = self.ChildsModel( sys, init );

F = -(M_s * udd + D_s * ud + K_s * u); % Damit bekomme ich eine unendliche Kraft -> keine Konvergenz
%F = -(D_s * ud + K_s * u);
%warning('Ohne Einfluss der Massenmatrix der Dichtung, da sonst keine Konvergenz.')

self.h = [F; zeros(4,1)];

end