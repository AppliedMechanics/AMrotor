function [Pyx,f,Nblocks] = acsdw(x,y,fs,N,POverlap);
%ACSDW Calculate cross PSD from time data, Welch's method (standard)
%
%           [Pyx,f,Nblocks] = acsdw(x,y,fs,N,POverlap), OR
%           [Pyx,f,Nblocks] = acsdw(x,y,fs,w,POverlap)
%
%           Pyx         CSD of time signal y, N/2+1-by-D-by-R
%           f           Frequency vector for Pyy, N/2+1-by-1
%           Nblocks     Number of overlapped FFT blocks used (see WELCHERR)
%
%           x           Input time signal(s)
%           y           Output time signals in column vector(s). If more than one
%                       column, each column is treated separately
%           fs          Sampling frequency for x, and y
%           N           FFT block size, power of 2 (1024, 2048,...), OR,
%           w           time window, e.g. ahann(1024)
%           POverlap    Overlap in percent >= 0 (default = 50)
%
%           D           Number of time records (columns in y)
%           R           Number of references (columns in x)
%
% ACSDW by default uses 50% overlap and Hanning window to produce the CSDs 
% using all time data in x and y (or as much as fits the blocksize and overlap). 
% The mean values of (each column in) x and y are removed before processing.
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters
if nargin < 4
   error('Wrong number of input variables, must be 4 or 5!');
elseif nargin == 4
    [m,n]=size(N);
    if m == n
        w=ahann(N);
    else
        w=N;
        N=length(w);
    end
    NOverlap=N/2;
elseif nargin == 5
    [m,n]=size(N);
    if m == n
        w=ahann(N);
    else
        w=N;
        N=length(w);
    end
    NOverlap=floor(POverlap*N/100);
end

% Check enough data
if length(y(:,1)) < N
    error('Not enough data, not even one time block!')
end
% Make input and output signals equally long, if different lengths
if length(x(:,1)) ~= length(y(:,1))
    L=min(length(x(:,1)),length(y(:,1)))
    x=x(1:L,:);
    y=y(1:L,:);
end

% Set up parameters
df=fs/N;
blkstep=N-NOverlap;
Be=winenbw(w);
acf=winacf(w);
R=length(x(1,:));               % Number references (inputs)
D=length(y(1,:));               % Number responses (outputs)

% Process each time block (column) in y and accumulate PSD
Nsamp=length(x(:,1));
M=floor((Nsamp-N)/blkstep+1);
Pyx=zeros(N/2+1,D,R);
for ref = 1:R
    x(:,ref)=x(:,ref)-mean(x(:,ref));           % Remove mean
    for resp = 1:D
        y(:,resp)=y(:,resp)-mean(y(:,resp));    % Remove mean
        for n = 1:M                             % Loop through averages
            i1=1+(n-1)*blkstep;                     % First sample in current block
            i2=i1+N-1;                              % Last sample in current block
            x_tmp=x(i1:i2,ref);                     % Reference block
            y_tmp=y(i1:i2,resp);                    % Response block
            X=acf*fft(x_tmp.*w)/N;                  % Scaled, windowed FFT, ampl. corrected
            Y=acf*fft(y_tmp.*w)/N;                  % Scaled, windowed FFT, ampl. corrected
            YX=Y.*conj(X);                          % Pyx=E[Y*conj(X)]
            Pyx(:,resp,ref)=(n-1)/n*Pyx(:,resp,ref)+YX(1:N/2+1)/n;   % Single-sided values
        end
    end
    Pyx(2:end,:,ref)=2*Pyx(2:end,:,ref);        % Single-sided scaling, not DC component
end
% Divide by equiv. bandwidth
Pyx=Pyx/df/Be;
f=(0:fs/N:fs/2)';
if nargout == 3
    Nblocks=M;
end

