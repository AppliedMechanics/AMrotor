function [Lyy,f] = alinspec(y,fs,w,M,ovlp);
%ALINSPEC Calculate linear (rms) spectrum from time data
%
%           [Lyy,f] = alinspec(y,fs,w,M,ovlp)
%
%           Lyy         Linear spectrum of time signal y
%           f           Frequency vector for Pyy, N/2+1-by-1
%
%           y           Time data in column vector(s). If more than one
%                       column, each column is treated separately
%           fs          Sampling frequency for y
%           w           Time window with length(FFT blocksize), power of 2 (1024, 2048,...)
%           M           Number of averages (FFTs), default is 1
%           ovlp        Overlap in percent, default is 0
%
%           D           Number of vectors (columns) in y
%
% Example: 
%           [Lyy,f]=alinspec(y,1000,aflattop(1024),10,50)
% Computes a linear spectrum using a flattop window with 1024 blocksize, 10
% averages, with 50% overlap
%
% ALINSPEC produces a linear, rms weighted spectrum as if y was a periodic
% signal. A peak in Lyy is interpreted as a sine at that frequency with an
% RMS value corresponding to the peak value in Lyy.
%
% See also winacf apsdw ahann aflattop

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters
if nargin < 3
   error('Wrong number of input variables, must be at least 3!');
elseif nargin == 3
    M=1;
    ovlp=0;
elseif nargin == 4
    ovlp=0;
elseif nargin == 5
elseif nargin > 5
   error('Wrong number of input variables, must be 3, 4, or 5!');
end

% Set up parameters
N=length(w);                % FFT block size
df=fs/N;                    % Frequency increment
acf=winacf(w);              % Window amplitude correction factor
K=floor((1-ovlp/100)*N);        % Overlap in samples
if length(y(:,1)) < N
    error('Not enough data, not even one time block!')
end

% Process each time block (column) in y
[Nsamp,Nvectors]=size(y);
% Check that specified overlap and number of FFTs does not exhaust data
L=N+(M-1)*K;
if L > Nsamp
    error('Not enough data in y to perform requested number of averages!')
end

Pyy=zeros(N,Nvectors);
for vec = 1:Nvectors
    y(:,vec)=y(:,vec)-mean(y(:,vec));     % Remove mean
    n=1;                        % Block number
    i1=1+(n-1)*K;               % Index into x
    i2=i1+N-1;
    y_tmp=y(i1:i2,vec);
    Y=acf*fft(y_tmp.*w)/N;      % Scaled, windowed FFT
    Pyy(:,vec)=abs(Y).^2;       % Window (amplitude) correction
    n=2;                        % Next block number
    i1=1+(n-1)*K;               % Index into y
    i2=i1+N-1;
    while  n <= M 
        y_tmp=y(i1:i2,vec);
        Y=acf*fft(y_tmp.*w)/N;
        Pyy(:,vec)=(n-1)/n*Pyy(:,vec)+abs(Y).^2/n; % Linear average accumulation
        n=n+1;
        i1=1+(n-1)*K;            % Index into x
        i2=i1+N-1;
    end
end
% Convert to single-sided spectra and take square root
Pyy=Pyy(1:N/2+1,:);
Pyy(2:end,:)=2*Pyy(2:end,:);
Lyy=sqrt(Pyy);
f=(0:df:N/2*df)';

