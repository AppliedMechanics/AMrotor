function x = abrand(N,NBlocks,BurstLength,P,f);
% ABRAND Create burst random time data blocks in column vector
% 
%        x = abrand(N,NBlocks,BurstLength,P,f)
%
%       x               Excitation signal with NBlocks blocks of size N
%
%       N               Blocksize
%       NoBlocks        Number of blocks
%       BurstLength     Burst length in % of NFFT (50 default)
%       P               PSD for spectrum shaping (optional)
%       f               Frequency axis for P

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 2
    BurstLength=50;
end
BurstN=round(N*BurstLength/100);

% Create noise for entire signal, shaped or not
if nargin == 5
    x=psd2time(P,f,N*NBlocks);
else
    x=randn(N*NBlocks,1);
end

% Zero out end of blocks
Z=zeros(N-BurstN,1);
for n = 1:NBlocks
	x((n-1)*N+1+BurstN:n*N)=Z;
end