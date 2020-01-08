function dZ = integrate_function(t,Z,Omega, rotorsystem, mat)

A=mat.A;
B=mat.B;
ndof = length(A)/2;

%% Loadvector
h_ges = rotorsystem.compute_system_load_ss(t,Z(1:2*ndof));

%% DGL
dZ = A*Z+B*h_ges; 
dZ(ndof+6:6:2*ndof) = 0; % angular acceleration = 0 for stationary rpm

end

