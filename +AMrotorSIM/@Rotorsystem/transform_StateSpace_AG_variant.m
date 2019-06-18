 function transform_StateSpace_AG_variant(obj,rpm)
% Neuberechnung von AG
    Omega = rpm / 60 * 2*pi;
    G=obj.systemmatrices.G*Omega; % Gyroskopie
    M_inv = obj.systemmatrices.M_inv; 
            
    obj.systemmatrices.ss.AG = sparse([zeros(length(M_inv)),zeros(length(M_inv));zeros(length(M_inv)),-M_inv*G]);

 end