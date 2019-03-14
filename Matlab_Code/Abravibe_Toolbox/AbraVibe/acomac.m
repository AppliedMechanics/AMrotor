function C = acomac(V1,V2)
% AMAC  Calculate Coordinate Modal Assurance Critera matrix C from two mode sets
%
%       C = acomac(V1,V2)
%
%       C           MAC matrix
%
%       V1          First mode shape matrix with modes in columns
%       V2          Second mode shape matrix
%
% NOTE: You have to assure that the modes in each mode set come in the
% same order!

% Copyright (c) 2017 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2017-09-11  
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1
    error('Too few inputs; need to be two mode sets!');
end

[N1,M1]=size(V1);
[N2,M2]=size(V2);

if N1 ~= N2
    error('Mode sets do not agree! Not same number of DOFs!')
end
% If different number of modes, select minimum number
M=min(M1,M2);

% Scale both mode sets to unity length
for m=1:M
    V1(:,m)=V1(:,m)/(norm(V1(:,m)));
    V2(:,m)=V2(:,m)/(norm(V2(:,m)));
end

C=zeros(N1,1);
for n = 1:N1
        C(n)=sum(abs(V1(n,:).*V2(n,:))).^2/(V1(n,:)*V1(n,:)')/(V2(n,:)*V2(n,:)');  
    end
end
