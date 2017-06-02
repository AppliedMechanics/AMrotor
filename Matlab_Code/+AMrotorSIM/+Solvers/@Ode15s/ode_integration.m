
Z0 = cumpute_Z0_rotor(M,0, omega,domega,method); %init vector
% solver parameters
omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 
options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6); %'OutputFcn','odeprint' as option to display steps
if (exist('verbose','var'))
    if verbose == 1
    options = odeset('OutputFcn','odeprint', 'OutputSel',1);
    end
end

% ODE function

[obj.result.T,Z] = ode15s(@rotor_sys_function,obj.time,Z0,options,K,M,D,G,h,omega_rot_const_force,method);

