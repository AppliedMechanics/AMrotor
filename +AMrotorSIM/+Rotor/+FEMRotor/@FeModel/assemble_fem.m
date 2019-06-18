function assemble_fem(self)

n_nodes=length(self.mesh.nodes);

%Lokalisierungsmatrix hat 12x6n 0 Einträge
%Element L wird dann an der Stelle (i-1)*6 drauf addiert.

M=sparse(6*n_nodes,6*n_nodes);
i=0;
for ele = self.mesh.elements
    i=i+1;
    L_ele = sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=ele.localisation_matrix;

    M=M+L_ele'*ele.mass_matrix*L_ele;
end
self.matrices.M = M;

K=sparse(6*n_nodes,6*n_nodes);
i=0;
for ele = self.mesh.elements
    i=i+1;
    L_ele = sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=ele.localisation_matrix;

    K=K+L_ele'*ele.stiffness_matrix*L_ele;
end
self.matrices.K = K;


G=sparse(6*n_nodes,6*n_nodes);
i=0;
for ele = self.mesh.elements
    i=i+1;
    L_ele = sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=ele.localisation_matrix;

    G=G+L_ele'*ele.gyroscopic_matrix*L_ele;
end
self.matrices.G = G;

%% Rayleigh-Damping

alpha1=self.material.rayleigh_alpha1;
alpha2=self.material.rayleigh_alpha2;

self.matrices.D = alpha1*K + alpha2*M;


end