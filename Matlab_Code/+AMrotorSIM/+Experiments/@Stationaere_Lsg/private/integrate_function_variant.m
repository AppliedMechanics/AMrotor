function dZ = integrate_function_variant(t,Z,Omega, rotorsystem, mat)

A=mat.A;
B=mat.B;
ndof = length(A)/2;

Z(2*ndof)=Omega; % node on the right is driven with constant omega

%% Loadvector
h_ges = rotorsystem.compute_system_load_variant(t,Z(1:2*ndof));

%% DGL
dZ = A*Z+B*h_ges; 

end

