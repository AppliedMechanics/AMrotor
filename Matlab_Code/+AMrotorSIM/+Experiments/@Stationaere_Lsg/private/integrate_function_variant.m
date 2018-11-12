function dZ = integrate_function_variant(t,Z,omega, rotorsystem, mat)

% A = rotorsystem.systemmatrices.ss.A;
% B = rotorsystem.systemmatrices.ss.B;
% ss_AG = rotorsystem.systemmatrices.ss.AG;
% A = A+ss_AG;

A=mat.A;
B=mat.B;


%% Loadvector

h_ges = rotorsystem.compute_system_load_variant(t,Z,omega);
% h_ges = zeros(length(mat.A),1);

%% DGL
% t %Zeit ausgeben um Fortschritt zu kontrollieren!
% fprintf(repmat('\b', 1, 11)); % Zeit ausgeben und wieder loeschen, sodass Uebersichtlichkeit erhalten bleibt
% fprintf('t = %04.0f',t*1000)
% fprintf(' ms')

dZ = A*Z+B*h_ges;
end

