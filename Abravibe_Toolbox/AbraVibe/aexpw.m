function w=aexpw(N, EndFactor);
%AEXPW Exponential window for impact testing
%
%           w=aexpw(N, EndFactor);
%
% Creates an exponential window of length Length,
% and a decay so that the last value of the window equals
% the value of EndFactor, in percent. w is a column vector.
%
% Example: w=expw(1024, 1);
% produces a 1024 samples long window, with 0.01 being the last value.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if EndFactor < 100
    Last=-log(EndFactor/100);
    x=(0:Last/(N-1):Last);
    w=exp(-x)';
else
    w=ones(N,1);
end
