function w = aflattop(N,type);
%AFLATTOP Calculate flattop window
%
%       w = aflattop(N,type);
%
%       w       Time window in column vector
%       
%       N       Window length. As opposed to MATLAB SP toolbox, this
%               window is periodic, that is, the first value is zero, and
%               the window ends one sample before being zero again.
%       type    'iso' or 'enhanced' (default). See inside file for details.
%
% The flattop window should be used whenever the peak of a tone (periodic
% spectrum component) is to be estimated. The window is wide in frequency,
% so the frequency increment must be large enough so there are no other
% tones within at least +/-8 spectral lines or more.
%
% See also winenbw winacf ahann

% Reference
% To Tran et al., "Design and Improvement of Flattop Windows with Semi-Infinite
% Optimization,", In: Proc. of the 6th International Conference on Optimization :
% Techniques and Applications, Ballarat, Australia, 2004.

% ISO 18431-2:2004, "Mechanical vibration and shock -- Signal processing --
% Part 2: Time domain windows for Fourier Transform Analysis," www.iso.org.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Define parameters according to type
if nargin == 1 
    type='enhanced';
end

if strcmp(upper(type),'ISO')
    a0=1;
    a1=1.933;
    a2=1.286;
    a3=0.388;
    a4=0.0322;
elseif strcmp(upper(type),'ENHANCED')
    a0=1;
    a1=1.93293488969277;
    a2=1.28349769674027;
    a3=0.38130801681619;
    a4=0.02929730258511;
end

% Create vector index
t=2*pi*(0:1/N:1-1/N);

% Create the window and turn it into column
w=a0-a1*cos(t)+a2*cos(2*t)-a3*cos(3*t)+a4*cos(4*t);
w=w(:);
