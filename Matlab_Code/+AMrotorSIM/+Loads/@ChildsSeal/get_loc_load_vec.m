function get_loc_load_vec(obj,~,omega,u_node)

u = u_node(1:2);

% dof-order: ux,uy,uz,psix,psiy,psiz

rpm = omega/2/pi*60;

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

[ M_s,D_s,K_s ] = obj.ChildsModel( sys, init );

F = M_s * udd + D_s * ud + K_s * u; % Problem: Wie bekomme ich die Beschleunigung des Knotens?

obj.h = [F; zeros(4,1)];

end