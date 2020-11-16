function compute_ode15s_ss(obj)
% Carries out an integration of type ode15s
%
%    :return: Integration results in results field of object

% Licensed under GPL-3.0-or-later, check attached LICENSE file

rpm_span = obj.drehzahlen;
t_span = [obj.time(1), obj.time(end)];

Timer = AMrotorTools.Timer();

disp('Compute Hochlauf .... ode15s State Space ....')
obj.rotorsystem.check_for_non_integrable_components;
obj.clear_time_result()
obj.result = containers.Map('KeyType','double','ValueType','any');
n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);

%%init Vector
nNodes = length(obj.rotorsystem.rotor.mesh.nodes);
ndof = 6*nNodes;
Z0 = zeros(2*ndof,1);     % Mit null belegen:
Z0(1*ndof+6:6:2*ndof)=rpm_span(1)/60*2*pi;        % Drehzahl fuer psi_z

% solver parameters
options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcnController,'MaxStep',obj.time(2)-obj.time(1));

Timer.restart();
disp('... integration started...')

sol = ode15s(@integrate_function,obj.time,Z0, options, rpm_span, t_span, obj.rotorsystem);

disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

[Z,Zp] = deval(sol,obj.time);

res.X = Z(1:6*n_nodes,:);
res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);
res.F = obj.rotorsystem.calculate_force_load_post_sensor(obj.time,res.X,res.X_d);
res.Fcontroller = obj.rotorsystem.calculate_controller_force(obj.time,res.X,res.X_d);

obj.result(rpm_span(1))=res;
obj.result(rpm_span(2))=res;
end