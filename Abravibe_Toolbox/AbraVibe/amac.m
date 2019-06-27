function M = amac(V1,V2)
% AMAC  Calculate Modal Assurance Critera matrix M from two mode sets
%
%       M = amac(V1,V2)
%
%       M           MAC matrix
%
%       V1          First mode shape matrix with modes in columns
%       V2          Second mode shape matrix (optional)
%
% M = amac(V1)      produces an auto MAC (V1 vs. V1 shapes)
% M = amac(V1,V2)   produces a cross MAC
%
% The number of modes do not need to be the same, but the number of rows in
% both matrices (DOFs) must (of course) be the same

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1
    V2=V1;
end

[N1,M1]=size(V1);
[N2,M2]=size(V2);

for m1 = 1:M1
    for m2=1:M2
        M(m1,m2)=(abs(V1(:,m1)'*V2(:,m2))^2/(V1(:,m1)'*V1(:,m1))/(V2(:,m2)'*V2(:,m2)));
    end
end
