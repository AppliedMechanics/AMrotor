function dZ = integrate_function_variant(t,Z,omega, rotorsystem)

A = rotorsystem.systemmatrices.ss.A;
B = rotorsystem.systemmatrices.ss.B;
%ss_AG = rotorsystem.systemmatrices.ss.AG;


%% Loadvector

h_ges = rotorsystem.compute_system_load_variant(t,Z);

%% DGL
t %Zeit ausgeben um Fortschritt zu kontrollieren!

dZ = A*Z+B*h_ges;
end

