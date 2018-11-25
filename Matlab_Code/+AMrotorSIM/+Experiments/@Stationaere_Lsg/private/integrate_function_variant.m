function dZ = integrate_function_variant(t,Z,omega, rotorsystem, mat)

% A=mat.A;
% B=mat.B;

M = mat.M;
D = mat.C + mat.G*omega;
K = mat.K;

%% Loadvector

h_ges = rotorsystem.compute_system_load_variant(t,Z,omega);
% h_ges = zeros(length(mat.A),1);

%% DGL

% Z1 = Z(1:end/2);
% Z2 = Z(end/2+1:end);
% dZ1 = Z2;
% dZ2 = M \ ( -K*Z1 -D*Z2 +h_ges(end/2+1:end) );
% dZ = [dZ1; dZ2];

dZ = A*Z+B*h_ges;
end

