function y = timeavg(x,N)
% TIMEAVG       Create synchronuous time average using blocksize N
%
%       y = timeavg(x,N)
%
%       y       Averaged output signal
%
%       x       Input signal
%       N       Blocksize

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

L=floor(length(x)/N);
x=x(:);
y=zeros(N,1);
for n=1:L
    y=((n-1)*y+x((n-1)*N+1:n*N))/n;
end
