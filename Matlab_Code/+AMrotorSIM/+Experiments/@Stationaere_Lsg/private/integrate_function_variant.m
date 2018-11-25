function dZ = integrate_function_variant(t,Z,omega, rotorsystem, mat)

A=mat.A;
B=mat.B;

%% Loadvector
h_ges = rotorsystem.compute_system_load_variant(t,Z,omega);

%% DGL
dZ = A*Z+B*h_ges;
end

