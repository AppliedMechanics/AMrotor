function y = arms(varargin);
% ARMS      RMS calculation by 'analog' or linear integration 
%
%       y = arms(x,fs,tau) computes an 'analog' integration of x(t),using a
%           time constant of tau (seconds), and a sampling frequency of fs
%           Hz is assumed for x(t).
%
%       y = arms(x) computes the rms of x the 'direct' way as
%           sqrt(mean(x(n)^2))
%
% Note that arms(x,fs,tau) produces a time-varying output, whereas 
% y = arms(x) only produces one value. To produce the Leq value, you should
% use
% >> Leq = sqrt(sum(y.^2));
% This function  with 'analog' integration is useful for acoustic rms calculations,
% and for ISO2631 human vibration filtering, etc.
% This function with the direct method is similar to using STD, but
% includes the mean(x)

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 3
    x=varargin{1};
    fs=varargin{2};
    tau=varargin{3};
    wc=1/tau;
    dt=1/fs;
    k=exp(-wc*dt);
    B=1-k;
    A=[1 -k];
    y=filter(B,A,x.^2);     % Filter squared signal with time constant
    y=sqrt(y);
elseif nargin == 1
    x=varargin{1};
    y=sqrt(mean(x.^2));
else
    error('Wrong number of input arguments!')
end
