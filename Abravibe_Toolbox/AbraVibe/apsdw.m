function [Pxx,f,Nblocks] = apsdw(x,fs,N,POverlap);
%APSDW  Calculate auto PSD from time data, Welch's method (standard)
% 
%
%           [Pxx,f] = apsdw(x,fs,N,POverlap), OR
%           [Pxx,f] = apsdw(x,fs,w,POverlap)
%
%           Pxx         PSD of time signal x
%           f           Frequency vector for Pxx, N/2+1-by-D
%           Nblocks     Number of overlapped FFT blocks used (see WELCHERR)
%
%           x           Time data in column vector(s). If more than one
%                       column, each column is treated separately
%           fs          Sampling frequency for x
%           N           FFT block size, power of 2 (1024, 2048,...), OR,
%           w           time window, e.g. ahann(1024)
%           POverlap    Percent overlap, >= 0
%
%           D           Number of time records (columns in x)
%
% NOTE: The normal use of APSDW should be [Pxx,f]=apswd(x,fs,N);
% APSDW then uses 50% overlap and Hanning window to produce the PSD 
% using all time data in x (or as much as fits the blocksize and overlap). 
% The mean value of (each column in) x is removed before processing.
%
% See also WELCHERR ACSDW acsdbt

% THIS FILE REPLACES FORMER FILE ACSD.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters
if nargin < 3
   error('Wrong number of input variables, must be 3 or 4!');
elseif nargin == 3
    [m,n]=size(N);
    if m == n
        w=ahann(N);
    else
        w=N;
        N=length(w);
    end
    NOverlap=N/2;
elseif nargin == 4
    [m,n]=size(N);
    if m == n
        w=ahann(N);
    else
        w=N;
        N=length(w);
    end
    NOverlap=floor(POverlap*N/100);
end

if length(x(:,1)) < N
    error('Not enough data, not even one time block!')
end

% Set up parameters
df=fs/N;
blkstep=N-NOverlap;
Be=winenbw(w);
acf=winacf(w);

% Process each time block (column) in x and accumulate PSD
[Nsamp,Nvectors]=size(x);
M=floor((Nsamp-N)/blkstep+1);
Pxx=zeros(N/2+1,Nvectors);
for vec = 1:Nvectors
    x(:,vec)=x(:,vec)-mean(x(:,vec));       % Remove mean
    for n = 1:M
        i1=1+(n-1)*blkstep;                     % First sample in current block
        i2=i1+N-1;                              % Last sample in current block
        x_tmp=x(i1:i2,vec);
        Y=acf*fft(x_tmp.*w)/N;                  % Scaled, windowed FFT, ampl. corrected
        Y2=abs(Y).^2;                           % Abs square
        Pxx(:,vec)=(n-1)/n*Pxx(:,vec)+Y2(1:N/2+1)/n;
    end
    Pxx(2:end,vec)=2*Pxx(2:end,vec);    % Single-sided scaling, not DC component       
end

% Divide by equiv. bandwidth
Pxx=Pxx/df/Be;
f=(0:fs/N:fs/2)';

% Export number of averages, for random error calculation (see welcherr)
if nargout == 3
    Nblocks=M;
end

