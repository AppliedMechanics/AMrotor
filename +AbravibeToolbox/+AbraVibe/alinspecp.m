function [Lyx,f] = alinspecp(y,x,fs,w,M,ovlp);
%ALINSPECP Calculate linear (rms) spectrum of time data, with phase
%
%           [Lyx,f] = alinspecp(y,x,fs,w,M,ovlp)
%
%           Lyx         Linear spectrum of time signal y with phase from Gyx
%           f           Frequency vector for Lyx, N/2+1-by-1
%
%           y           Time data in column vector(s). If more than one
%                       column, each column is treated separately
%           x           Time data for phase reference
%           fs          Sampling frequency for y
%           w           Time window with length(FFT blocksize), power of 2 (1024, 2048,...)
%           M           Number of averages (FFTs), default is 1
%           ovlp        Overlap in percent, default is 0
%
%           D           Number of vectors (columns) in y
%
% Example: 
%           [Lyx,f]=alinspecp(y,x,1000,aflattop(1024),10,50)
%
% ALINSPECP produces a linear, rms weighted spectrum as if y was a periodic
% signal. A peak in Lyx is interpreted as a sine at that frequency with an
% RMS value corresponding to the peak value in Lyx and with phase relative 
% to signal x.
%
% See also alinspec winacf apsdw ahann aflattop 

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2011-10-07 Fixed new syntax, was not working
%          1.2 2014-10-01 Fixed bug line 84
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters
if nargin < 4
   error('Wrong number of input variables, must be at least 4!');
elseif nargin == 4
    M=1;
    ovlp=0;
elseif nargin == 5
    ovlp=0;
elseif nargin > 6
   error('Wrong number of input variables, must be 4, 5, or 6!');
end

% Set up parameters
N=length(w);                % FFT block size
df=fs/N;                    % Frequency increment
acf=winacf(w);              % Window amplitude correction factor
K=floor((1-ovlp/100)*N);    % Overlap in samples
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
    x_tmp=x(i1:i2);
    Y=acf*fft(y_tmp.*w)/N;      % Scaled, windowed FFT
    YX=fft(y_tmp).*conj(fft(x_tmp));
    Pyy(:,vec)=abs(Y).^2;       % Window (amplitude) correction
    Pyx(:,vec)=YX;              % Cross spectrum accumulation
    n=2;                        % Next block number
    i1=1+(n-1)*K;               % Index into y
    i2=i1+N-1;
    while  n <= M 
        y_tmp=y(i1:i2,vec);
        x_tmp=x(i1:i2);
        Y=acf*fft(y_tmp.*w)/N;
        YX=fft(y_tmp).*conj(fft(x_tmp));
        Y=Y.*exp(j*angle(YX));  % Bug .* fixed 2014-10-01
        Pyy(:,vec)=(n-1)/n*Pyy(:,vec)+abs(Y).^2/n; % Linear average accumulation
        Pyx(:,vec)=(n-1)/n*Pyx(:,vec)+(YX)/n; % Linear average accumulation
        n=n+1;
        i1=1+(n-1)*K;            % Index into x
        i2=i1+N-1;
    end
    Ayx(:,vec)=Pyy(:,vec).*exp(j*angle(Pyx(:,vec)));     % Phased power spectrum
end
% Convert to single-sided spectra and take square root
Ayx=Ayx(1:N/2+1,:);
Ayx(2:end,:)=2*Ayx(2:end,:);
for vec=1:Nvectors
    Lyx(:,vec)=sqrt(abs(Ayx(:,vec))).*exp(j*angle(Ayx(:,vec)));
end
f=(0:df:N/2*df)';

