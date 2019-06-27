function [S,f] = asrs(x,fs,fmin,fmax,N,Q,type)
%ASRS Acceleration shock response spectrum, SRS
%
%       [S,f] = asrs(x,fs,fmin,fmax,N,Q,type)
%
%           S       Output shock response spectrum(s) of type <type>
%           f       frequency vector Hz
%
%           x       Input acceleration data (column) vector
%           fs      sampling frequency in Hz
%           fmin    first (lowest) SRS frequency in Hz
%           fmax    last (highest) SRS frequency in Hz
%           N       number of frequencies (in log spacing)
%           Q       Q value, can be vector to simultaneously calculate SRS
%                   for several Q values
%           type    SRS type as string: 'min', 'max', or 'maximax'
%           
% This function uses a ramp invariant transform formulation to calculate
% min, max, or maximax acceleration SRS from an acceleration input signal.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% References: This function is adapted after:
% Ahlin, K. (2006), 'Comparison of test specifications and measured field data', 
% Sound and Vibration 40(9), 22--25. See www.sandv.com.
%
% Also see: 18431-4:2007, Mechanical Vibration and Shock -- Signal
% Processing -- Part 4: Shock spectrum analysis International Standardization 
%Organisation, Geneva, Switzerland, International Organization for
%Standardization

% Check input parameters
if nargin < 6
    error('Not enough input parameters!')
end
if nargin == 6          % No output type defined - use maximax
    type='MAXIMAX';
else
    type=upper(type);
end

% Allocate output column vectors
S = zeros(N,length(Q));
f = zeros(N,length(Q));

% Define frequency increment
k1 = log(fmax/fmin)/(N-1);

for q = 1:length(Q)             % Loop through Q values
    k2 = pi/Q(q)/fs;
    k3 = 2*pi/fs*sqrt(1-1/(4*Q(q)^2));
    % Loop through each SDOF resonance frequency
    for n = 1:N;
        f0 = fmin*exp(k1*(n-1));
        A = k2*f0;
        B= k3*f0;
        a = [1, -2*cos(B)*exp(-A), exp(-2*A)];
        b = [1-exp(-A)*sin(B)/B,2*exp(-A)*(sin(B)/B-cos(B)),exp(-2*A)-exp(-A)*sin(B)/B];
        %
        z = filter(b,a,x);
        if strcmp(type,'MAXIMAX')
            S(n,q) = max(abs(z));
        elseif strcmp(type,'MAX')
            S(n,q) = max(z);
        elseif strcmp(type,'MIN')
            S(n,q) = min(z);
        else
            error('Wrong output type')
            break
        end
        f(n,1) = f0;
    end
end
