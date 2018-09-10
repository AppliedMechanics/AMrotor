function dZ = integrate_function_variant(t,Z,omega, rotorsystem)

A = rotorsystem.systemmatrices.ss.A;
B = rotorsystem.systemmatrices.ss.B;
%ss_AG = rotorsystem.systemmatrices.ss.AG;

%n_nodes = length(rotorsystem.rotor.mesh.nodes);

%% Lastvektor

h_ges = rotorsystem.compute_system_load_variant(t,Z);

% h_ges=sparse(2040,1);
% h_ges(1021)=10;

%% DGL
t %Zeit ausgeben um Fortschritt zu kontrollieren!

dZ = A*Z+B*h_ges;
end

