function dZ = integrate_function(t,Z,omega, rotorsystem)

ss_A = rotorsystem.systemmatrices.ss_A;
ss_B = rotorsystem.systemmatrices.ss_B;
ss_AG = rotorsystem.systemmatrices.ss_AG;

ss_A=ss_A+ss_AG*omega;

n_nodes = length(rotorsystem.rotor.mesh.nodes);

%% init Vector

phi=zeros(12*n_nodes,1);
omega=zeros(12*n_nodes,1);

for node = 1:n_nodes
    dof_x = rotorsystem.rotor.get_gdof('u_x',node);
    dof_psi_z = rotorsystem.rotor.get_gdof('psi_z',node);
    phi(dof_x:dof_x+1)=Z(dof_psi_z);
    omega(dof_x:dof_x+1)=Z(6*n_nodes+dof_psi_z);
end

domega=0;

h_ges = rotorsystem.compute_system_load(t,phi,omega, domega);

%% DGL
t %Zeit ausgeben um Fortschritt zu kontrollieren!

dZ = -ss_A\ss_B*Z+ss_A\h_ges;
end

