function y = timediff(x,fs,Type);
% TIMEDIFF Differentiate time signal 
%
%       y = timediff(x,fs,Type);
%
%       y       Time derivative of x
%
%       x       Input time signal, in columns if more than one channel
%       fs      Sampling frequency
%       Type    'Remez' (default and best), or 'MaxFlat' (faster)
%
% For Type='Remez' , an oversampling factor of 2.5 is sufficient. 
% For Type='MaxFlat' you should use at least 10 times oversampling.
%
% Note that both types of differentiation implemented by this command
% introduce different amounts of time delay. The samples before the delay 
% is reached are thrown away, so that the first sample in y is synchronous 
% with the first sample in x, which is suitable for input/output analysis 
% etc. This, however, means that the length of y is not equal to the length 
% of x! You should throw away the LAST samples of x if you want the data 
% to be same length and x synchronous with y.
%
% NOTE! For both methods, it is highly recommended that you throw away an
% additional 20 samples from the beginning of all your signals after 
% differentiation, as the diff. filters have some transient behavior!
%
% See inside timediff.m for more information on the different methods.
%
% See also TIMEINT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% 
% The 'Remez' method is using an optimal FIR filter design with a complex 
% relative error of < -120 dB up to fs/2.5.
% The filter produces an integer filter delay (of 20 samples). Odd order 
% filters perform better, but have a fractional delay, which is not suitable
% if analysis of unfiltered and filtered data are to be used, as for
% example in input/output analysis.
%
% The 'maxflat' method uses a 6-order maximum flat FIR filter with a
% recursive algorithm from reference
% Lebihan, J. "Maximally Linear Fir Digital Differentiators," Circuits
% Systems And Signal Processing, 1995, 14, 633-637.

Type=upper(Type);

% Check parameters
if nargin == 2
    Type='FIR';
    N=40;
elseif nargin == 3
    if strcmp(Type,'MAXFLAT')
        N=6;                           % Change to 2 or 4 for faster but less
                                         % accurate differentiation
    elseif strcmp(Type,'REMEZ')
        N=40;                          % Order (length-1) of FIR filter
        if strcmp(checksw,'OCTAVE')
            error('Remez type does not work in Octave!, choose Maxflat!');

        end
    else
        fprintf('Wrong parameter ''Type'', se help')
        return;
    end
end

[n,m]=size(x);
for k = 1:m
    x(:,k)=x(:,k)-mean(x(:,k));
end

% Process each case separately
if strcmp(upper(Type),'MAXFLAT')
    % Create simple differentiation filter
    [B,A]=mfdfilt(N);
    y=zeros(n,m);
    for k = 1:m
        y(:,k)=fs*filter(B,A,x(:,k));
    end
    y=y(N+1:end,:);             % Filter has N samples delay
elseif strcmp(upper(Type),'REMEZ')
    if strcmp(checksw,'MATLAB')
        B=fs*firpm(N,[0 0.8],[0 0.8*pi],'differentiator');
    elseif strcmp(checksw,'OCTAVE')
        B=fs*remez(N,[0 0.8],[0 0.8]*pi,'differentiator',4*1024);
    end        
    y=zeros(n,m);
    for k = 1:m
        y(:,k)=filter(B,1,x(:,k));
    end
    y=y(N/2+1:end,:);           % Filter has N/2 samples delay
end
