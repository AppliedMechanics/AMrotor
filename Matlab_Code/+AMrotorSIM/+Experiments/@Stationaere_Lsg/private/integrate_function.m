function dZ = integrate_function(t,Z,omega, rotorsystem)

%ss = rotorsystem.systemmatrices.ss;
%ss_G = rotorsystem.systemmatrices.ss_G;

ss_A = rotorsystem.systemmatrices.ss_A;
ss_B = rotorsystem.systemmatrices.ss_B;
ss_AG = rotorsystem.systemmatrices.ss_AG;

ss_A=ss_A+ss_AG*omega;
%ss=ss+ss_G*omega;

n_nodes = length(rotorsystem.rotor.mesh.nodes);

%% init Vector

phi=zeros(12*n_nodes,1);
omega=zeros(12*n_nodes,1);

for node = 1:n_nodes
    dof_psi_z = rotorsystem.rotor.get_gdof('psi_z',node);
    phi(dof_psi_z)=Z(dof_psi_z);
    omega(6*n_nodes+dof_psi_z)=Z(6*n_nodes+dof_psi_z);
end

domega=0;

%h_ges = rotorsystem.compute_system_load(t,phi,omega, domega);

h_ges=sparse(2040,1);
h_ges(601)=10;

%% DGL
t %Zeit ausgeben um Fortschritt zu kontrollieren!

plot(Z(1:6:end/2))
drawnow

dZ = -ss_A\ss_B*Z+ss_A\h_ges;
%dZ = ss*Z+h_ges;
end

