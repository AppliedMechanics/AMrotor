% Licensed under GPL-3.0-or-later, check attached LICENSE file

function compute_euler_ss(obj)
% Carries out an integration of type euler in state space (currently not working)
%
%    :return: Integration results in results field of object

    obj.rotorsystem.check_for_non_integrable_components;

    Timer = AMrotorTools.Timer();

    disp('Compute.... Forward Euler - State Space ....')
    obj.clear_time_result()

%-----EULER ------------------------------------------------------    

       for rpm = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(rpm),' U/min'])
        
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        Omega = rpm*pi/30;                                      %new        
        [mat.A,mat.B] = obj.get_state_space_matrices(Omega);    %new 
        ss_A = mat.A;                                           %new
        ss_B = mat.B;                                           %new

% ss_A = obj.rotorsystem.systemmatrices.ss_A;                   %old
% ss_B = obj.rotorsystem.systemmatrices.ss_B;                   %old


time=obj.time;
Z0 = zeros(length(ss_A),1);

h_ges = obj.rotorsystem.compute_system_load(0,Z0); % check if this is still ok with the current state space formulation for time integration

x=zeros(length(Z0),length(time));
x(:,1)=0;
dt=time(2)-time(1);
for i=2:length(time)
    h_ges = obj.rotorsystem.compute_system_load(time,x);
    x(:,i)=x(:,i-1)+dt*(-ss_A\ss_B*x(:,i-1)+ss_A\h_ges);
    plot(x(1:6:end/2,i))
    drawnow
end
Z=x;
%------------------------------------------------------------------

disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])
        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        
        obj.result(drehzahl)=res;

 end