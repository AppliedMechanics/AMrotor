function y = aprand(N,X);
% APRAND Create pseudo random time data block in column vector
% 
%        y = aprand(N, X)
%
%        N      Block size
%        X      Linear spectrum of record (optional, unity for all freqs if not given)
%               X MUST BE size N/2+1
%
% Creates one block of a pseudo random series with (optionally) specified
% spectrum which can be used for exciting a structure.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1
        X=ones(N/2+1,1);
        X(1)=0;
    else
        if length(X)~= N/2+1
            error('Size of amplitude spectrum must be NFFT/2+1!')
    end
end

ph=2*pi*(randn(N/2+1,1)-.5);
ph(N/2+1)=0;

f=(0:1/N:1/2)';
Y=X.*exp(j*ph);

y=frf2ir(Y,f);
y=y/std(y);