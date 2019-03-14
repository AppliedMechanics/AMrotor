function x = makexaxis(y,dx,x0);
%MAKEXAXIS Create a time or frequency x axis
%
%           x = makexaxis(y,dx,x0);
%
%           y       Y axis
%           dx      x increment
%           x0      Start x value (default = 0)
%
% This command can be used to create an x axis for time data as for example
% t=makexaxis(y,1/fs) if fs is the sampling frequency, and start is 0 sec.
% or for a spectrum by using
% f=makexaxis(Y,fs/N)
% if Y is a spectrum using blocksize N, starting at 0 Hz.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA
%

if nargin == 2
    x0=0;
end

N=length(y);
x=(x0:dx:x0+(N-1)*dx)';
