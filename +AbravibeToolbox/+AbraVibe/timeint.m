function y = timeint(x,fs,Type,Par);
% TIMEINT Integrate time signal 
%
%       y = timeint(x,fs,Type,Par)
%
%       y       Time integration of x
%
%       x       Input time signal
%       fs      Sampling frequency
%       Type    'simple', 'HPFilter','IIR', 'FFT', Default='iir'
%       Par     Extra parameter for HP, and IIR
%               For HPFilter:  Cutoff frequency for HP filter in Hz, 5 Hz default
%               For IIR: Cutoff frequency for HP filter in Hz, 5 Hz default
%               For FFT: Number of low frequency frequency lines set to zero
%
% For good performance, x should be oversampled by a factor of >=10, except
% for IIR, where a factor 4 is sufficient, or for FFT where it is not necessary.
% Note that the IIR type introduces a delay by (exactly) 23 samples, and that
% those first samples in the output sequency are thrown away by TIMEINT! Thus
% length(y)=length(x)-23 for IIR type filter, so that the first sample in y is
% synchronous with the first sample in x.
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23 
%          1.1 2012-06-07   Added functionality to work for more than one
%                           signal, and check that data are in columns.
%          1.2 2017-11-11   Added 'FFT' method, performing one long FFT per
%                           channel.
%          1.3 2018-03-09   Correct option 'HPFILTER' to work on columns in x
%
% This file is part of ABRAVIBE Toolbox for NVA
% 

% The IIR filter is taken from 
% Pintelon and Schoukens, "Real-Time Integration and Differentiation
% of Analog Signals by Means of Digital Filtering," IEEE Trans. on Instr.
% and Meas., Vol 39, No 6, pp. 923–927, December 1990.
%
% For FFT integration, see
% Brandt, A. & Brincker, R. "“Integrating time signals in frequency domain 
% – Comparison with time domain integration,” Measurement, vol. 58, pp. 511–519, 2014.


% Check parameters
if nargin == 2
    Type='IIR';
    Par=5;
elseif nargin == 3
    if strcmp(upper(Type),'SIMPLE')
        Par=[];
    elseif strcmp(upper(Type),'HPFILTER')
        Par=5;                          % Cutoff frequency of butterworth filter
    elseif strcmp(upper(Type),'IIR')
        Par=5;                          % Cutoff frequency of FIR filter, see below
    elseif strcmp(upper(Type),'FFT')
        Par=1;                          % Cutoff frequency of FIR filter, see below
    else
        fprintf('Wrong parameter ''Type'', se help')
        return;
    end
elseif nargin == 4
    if strcmp(upper(Type),'SIMPLE')
        fprintf('Wrong number of parameters for Type ''SIMPLE''')
        return;
    end
end

% Added 7.6-2012: Make work for more than one signal
[n,m]=size(x);
if n == 1
    error('Data must be in columns!')
elseif m == 1
    x=x-mean(x);
else
     x=x-ones(n,1)*mean(x);
end
    
    
% Process each case separately
if strcmp(upper(Type),'SIMPLE')
    % Create 'trapezoidal rule' filter
    B=1/2/fs*[1 1];
    A=[1 -1];
    y=zeros(n,m);
    for c = 1:m
        y(:,c)=filter(B,A,x(:,c));
    end
elseif strcmp(upper(Type),'HPFILTER')
    % Create a 1. order HP filter with cutoff frequency Par
    % This is equivalent to the "old", analog integrator found in for
    % example charge amplifiers
    fnyq=fs/2;                  % Nyquist frequency
    frel=Par/fnyq;              % Relative cutoff frequency as wanted by butter
    Amp=1/(2*pi*Par);           % Butterworth has a unity numerator, HP filter does not
    [B,A]=butter(1,frel)       % 1. order HP filter coefficients
    y=zeros(n,m);
    for c=1:m
        y(:,c)=Amp*filter(B,A,x(:,c));        % Integrate time signal
    end
elseif strcmp(upper(Type),'IIR')
    % Calculate a 32-pin, linear-phase FIR HP filter by a constrained least
    % squares solution, ir Par is not = 0
    if Par ~= 0
        fnyq=fs/2;                  % Nyquist frequency
        Nfir=32;                    % FIR filter length
        fcn=Par/fnyq;               % Normalized cutoff frequency
        dp=1e-6;                    % Passband deviation, to achieve 120 dB total dynamic range
        ds=1e-6;                    % stopband attenuation
        ft=2*fcn;                   % Frequency above which dp is achieved
        %     if strcmp(checksw,'MATLAB')
        %         Bf=fircls1(Nfir,fcn,dp,ds,ft,'high')   % Compute FIR filter
        %     elseif strcmp(checksw,'OCTAVE')
        Bf=firls(Nfir,[0 fcn 1.1*fcn 1],[0 0.9 1 1]);
        %     end
        % Use 8th order IIR filter by Pintelon and Schoukens, se ref above
    else
        Nfir=0;
    end
    p=zeros(8,1);
    p(1)=-0.5805235;
    p(2)=0.2332021*exp(j*114.0968*pi/180);
    p(3)=conj(p(2));
    p(4)=0.1814755*exp(j*66.33969*pi/180);
    p(5)=conj(p(4));
    p(6)=0.1641457*exp(j*21.89539*pi/180);
    p(7)=conj(p(6));
    p(8)=0.9999999999;
    z=zeros(8,1);
    z(1)=-1.175839;
    z(2)=3.37102*exp(j*125.1125*pi/180);
    z(3)=conj(z(2));
    z(4)=4.54971*exp(j*80.96404*pi/180);
    z(5)=conj(z(4));
    z(6)=5.223966*exp(j*40.09347*pi/180);
    z(7)=conj(z(6));
    z(8)=5.443743;
    A=poly(p);
    Const=1.951579134931078e-005;
    B=-Const*poly(z);           % Some sign and scale factor not in P&S paper
    Amp=1/fs;   
    D=8+Nfir/2;                           % First sample after delay caused by both filters
    y=zeros(n-D+1,m);                       
    for c=1:m                                 % Loop added 2012-06-07
        if Par ~= 0
            x(:,c)=filter(Bf,1,x(:,c));       % Highpass filter x
        end
        yt=filter(B,A,x(:,c));                % Integrate time signal
        yt=Amp*yt;
        yt=yt(D:end);                         % Throw away initial samples during delay period
        y(:,c)=yt; %-mean(yt);                % We assume dynamic signal without static part!
    end
elseif strcmp(upper(Type),'FFT')
    if mod(n,2) ~= 0                          % Ensure even length data
        x=x(1:end-1,:);
    end
    N=2*length(x(:,1));                       % FFT size
    df=fs/(N);
    y=zeros(N/2,length(x(1,:)));
    for c=1:m
        X=fft(x(:,c),N);
        X=X(1:N/2+1);
        f=makexaxis(X,df);
        jw=j*2*pi*f;
        Y=X./jw;
        Y(1:Par)=0;
        Yn=fnegfreq(Y,'fft');
        yn=real(ifft(Yn));
        yn=yn(1:length(yn)/2);
        yt=detrend(yn);
        y(:,c)=yt;
    end
end