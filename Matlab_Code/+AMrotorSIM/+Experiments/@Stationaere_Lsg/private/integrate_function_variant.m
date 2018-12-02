function dZ = integrate_function_variant(t,Z,Omega, rotorsystem, mat)

Z(end)=Omega; % node on the right is driven with constant oemga

persistent qdotdot

A=mat.A;
B=mat.B;

if isempty(qdotdot)
    qdotdot = zeros(length(A)/2,1);
end

%% Loadvector
h_ges = rotorsystem.compute_system_load_variant(t,Z,qdotdot);

%% DGL
dZ = A*Z+B*h_ges; % dZ = [qdot, qdotdot], Z = [q, qdot]
qdotdot = dZ(end/2+1:end);
end

