function Z0 = cumpute_Z0_rotor(M,phi, omega,domega,method)

% initial conditions
dim_M=size(M);              % parameter for calculation 


%Stationär
if method == 0

Z0 = zeros(2*dim_M(1)+2,1); % state vector for ode funcion rotor_sys_function

Z0(end-1) = phi;              % phi        [rad]
% 
Z0(end)   = omega;            % omega_ode  [1/s]  
end



% instationär
if method == 1

Z0 = zeros(2*dim_M(1)+3,1); % state vector for ode funcion rotor_sys_function

Z0(end-2) = phi;              % phi        [rad]
% 
Z0(end-1) = omega;            % omega_ode  [1/s]  

Z0(end)   = domega;

end





end