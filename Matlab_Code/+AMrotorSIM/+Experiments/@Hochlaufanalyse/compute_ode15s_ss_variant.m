function compute_ode15s_ss_variant(obj)
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
Z0 = zeros(2*6*nNodes,1);     % Mit null belegen:
Z0(end/2+6:6:end)=obj.drehzahlen(1);        % Drehzahl fuer psi_z initialisieren

% solver parameters
options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcn_plotBeam);
% options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5); % ohne live-plot

Timer.restart();
disp('... integration started...')

sol = ode15s(@integrate_function_variant,obj.time,Z0, options, rpm_span, t_span, obj.rotorsystem);

disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

[Z,Zp] = deval(sol,obj.time);

res.X = Z(1:6*n_nodes,:);
res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);

obj.result(rpm_span(1))=res;
obj.result(rpm_span(2))=res;
end