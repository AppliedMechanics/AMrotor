function dZ = integrate_function_variant(t,Z,Omega, rotorsystem, mat)

A=mat.A;
B=mat.B;
ndof = length(A)/2;

A=[A, zeros(2*ndof,ndof); zeros(ndof,2*ndof), eye(ndof)];
B=[B, zeros(2*ndof,ndof); zeros(ndof,2*ndof), zeros(ndof)];

Z(2*ndof)=Omega; % node on the right is driven with constant omega

qdotdot = Z(ndof*2+1:end);


%% Loadvector
h_ges = rotorsystem.compute_system_load_variant(t,Z(1:2*ndof),qdotdot);
h_ges = [h_ges; zeros(ndof,1)];

%% DGL
dZ = A*Z+B*h_ges; 

% expanded state-space to maintain acceleration information for next integration step
% dZ = [qdot, qdotdot, qdotdot], Z = [q, qdot, qdotdot]

end

