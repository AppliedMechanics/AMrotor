function Cm = mcoh(Gxx,Gyy,H);
%MCOH Calculate multiple coherence
%
%               Cm = mcoh(Gxx,Gyy,H)
%
%   Output Variables:
%               Cm    Multiple coherence (matrix) N-by-D
%               N     Number of frequency values
%               D     Number of responses
%   Input variables:
%               Gxx   Input cross spectrum matrix, N-by-R-by-R
%               Gyy   Output spectrum matrix, N-by-D
%               H     Frequency response matrix, N-by-D-by-R

%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


[N,D,R]=size(H);

Cm=zeros(N,D);

for d = 1:D                         % Loop through responses
    for n = 1:N                     % Loop through frequencies
        Gxxf=squeeze(Gxx(n,:,:));
        Hf=squeeze(H(n,d,:));
        Hf=Hf(:).';                 % Force to row
        Cm(n,d)=real((Hf*Gxxf*Hf')/Gyy(n,d));    
    end
end
