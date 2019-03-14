function [H,Cm,Cxx] = xmtrx2frf(Gxx,Gyx,Gyy)
%  XMTRX2FRF    FRF estimation (SISO, SIMO, MISO, or MIMO)
%
% Syntax:      [H,Cm,Cxx] = xmtrx2frf(Gxx,Gyx,Gyy)
%
% Output variables:
%               H       FRF matrix N-by-D-by-R
%               N number of frequency points
%               D number of outputs
%               R number of references
%               Cm      multiple coherence for outputs, N-by-D
%               Cxx     ordinary coherence(s) between inputs, N-by-R-by-R
% Input variables:
%               Gxx     input cross spectrum matrix from XMTRX, N-by-R-by-R
%               Gyx     input-output cross spectrum matrix from XMTRX, N-by-D-by-R
%               Gyy     output spectrum matrix from XMTRX, N-by-D
%
%  See also TIME2XMTRX APSDW ACSDW


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


% Parse Inputs:
[N,D,R] = size(Gyx);

% Allocate space for output matrices
H = zeros(N,D,R);
Cxx=zeros(N,R,R);

% Loop through frequencies
for n = 1:N
    Gxxp = permute(Gxx,[2 3 1]);
    Gxxf = Gxxp(:,:,n);
    Gyxp = permute(Gyx,[2 3 1]);
    Gyxf = Gyxp(:,:,n);
    H(n,:,:) = Gyxf/Gxxf;
end
%
% multiple coherence
Cm = mcoh(Gxx,Gyy,H);  

% Ordinary coherences between inputs if requested
%
if nargout == 3
    for n = 1:R
        for m = 1:R
            Cxx(:,n,m) = real(Gxx(:,n,m).*conj(Gxx(:,n,m))./Gxx(:,n,n)./Gxx(:,m,m));
        end
    end
end
% 
        

