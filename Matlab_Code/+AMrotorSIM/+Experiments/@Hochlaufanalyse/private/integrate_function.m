function dZ = integrate_function(t,Z,omega, rotorsystem)

ss_A = rotorsystem.systemmatrices.ss_A;
ss_B = rotorsystem.systemmatrices.ss_B;
ss_AG = rotorsystem.systemmatrices.ss_AG;

%ss_A=ss_A+ss_AG*omega;

%% Load Vector

h_ges = rotorsystem.compute_system_load(t,Z);

%% DGL
t %Zeit ausgeben um Fortschritt zu kontrollieren!

dZ = -ss_A\ss_B*Z+ss_A\h_ges;
end

