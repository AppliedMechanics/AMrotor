function [B,A] = mfdfilt(N)
% MFDFILT    Calculate filter coefficients for a maximum flat differentiator
%
%       [B,A] = mfdfilt(N)
%
%       B       Filter numerator coefficients
%       A       Filter denominator coefficients
%
%       N       Filter order, length(B) = 2N+1. MUST be even number for
%               integer sample filter delay
%
% 10 times oversampling should be used with these filters. Delay is N
% samples.
%
% See also TIMEDIFF

% This is an internal function used by timediff

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

c(1)=-N/(N+1);
for n = 2:N
    c(n)=(-1)*c(n-1)*(n-1)*(N-n+1)/n/(N+n);
end
% Filter coefficients
A=1;
B=-[fliplr(c) 0 -c];


