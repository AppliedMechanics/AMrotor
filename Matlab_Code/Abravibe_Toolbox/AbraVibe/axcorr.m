function [Ryx,t,Gyx,f] = axcorr(x,y,fs,N)
% AXCORR    Scaled cross-correlation between x (input) and y (output)
%
%       [Ryx,t,Gyx,f] = axcorr(x,y,fs,N)
%
%       Ryx         Scaled cross correlation, N+1-by-D-by-R
%       t           Time lag vector
%       Gyx         Single-sided PSD (Note! No window!), 2N-by-D-by-R
%       f           Frequency axis for Gyx
%
%       x           Input signal(s), with time data in R column(s) 
%       y           Output signal(s), with time data in D columns
%       fs          Sampling frequency
%       N           Length of correlation function
%
% This function estimates unbiased cross correlation using Welch's method.
% Use axcorr(x,x,...) to produce autocorrelation.
% Note that calculations are made on zero padded data with length 2N, so
% spectra are twice as large as from, e.g., APSDW.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-08-28 Fixed bug scaling first average
%          1.2 2016-07-08 Fixed bug for negative lags
% This file is part of ABRAVIBE Toolbox for NVA

% Set up parameters
df=fs/(2*N);                        % Blocks augmented by N zeros
ovlp=floor(N/2);
R=length(x(1,:));                   % Number references (inputs)
D=length(y(1,:));                   % Number responses (outputs)

% Process each time block (column) in x and y and accumulate CSD
Nsamp=length(x(:,1));
Syx=zeros(2*N,D,R);
for ref = 1:R
    x(:,ref)=x(:,ref)-mean(x(:,ref));           % Remove mean
    for resp = 1:D
        y(:,resp)=y(:,resp)-mean(y(:,resp));    % Remove mean
        n=1;                                    % Block number
        i1=1+(n-1)*ovlp;                        % First sample in next block
        i2=i1+N-1;                              % Last sample in next block
        x_tmp=x(i1:i2,ref);                     % Reference block
        y_tmp=y(i1:i2,resp);                    % Response block
        X=fft(x_tmp,2*N)/(2*N);                 % Zero-padded fft Bugfix 2012-08-28
        Y=fft(y_tmp,2*N)/(2*N);                 % Zero-padded fft Bugfix 2012-08-28
        Syx(:,resp,ref)=Y.*conj(X);            	% Double-sided PSD
        n=2;                                    % Next block number
        i1=1+(n-1)*ovlp;                        % Index into y
        i2=i1+N-1;
        while  i2 <= Nsamp                      % Loop through data with overlap
            x_tmp=x(i1:i2,ref);                 % Reference block
            x_tmp=[x_tmp;zeros(size(x_tmp))];   % Augment data with zeros
            y_tmp=y(i1:i2,resp);                % Response block
            y_tmp=[y_tmp;zeros(size(y_tmp))];   % Augment data with zeros
            X=fft(x_tmp)/(2*N);                 % Scaled, windowed FFT
            Y=fft(y_tmp)/(2*N);                 % Scaled, windowed FFT
            Syx(:,resp,ref)=(n-1)/n*Syx(:,resp,ref)+Y.*conj(X)/n;  % Double-sided average accumulation
            n=n+1;                              % Next average number
            i1=1+(n-1)*ovlp;                    % Index into y
            i2=i1+N-1;
        end
    end
end
Syx=2*Syx/df;     % Compensate for zero padding and scale to CSD

% Go through Syx and calculate corresponding Ryx, making it unbiased
Ryx=zeros(2*N,D,R);
% Calculate (inverse) window function
h=[ones(N,1);zeros(N,1)];
W=ifft(abs(fft(h)).^2);
w=N./W;
w(N+1)=0;           % Rt(N+1) below will be (practically) zero
for r = 1:R
    for d = 1:D
        Rt=ifft(Syx(:,d,r));
        Rt=w.*Rt*fs;
        Ryx(:,d,r)=fftshift(Rt);
    end
end
Ryx=Ryx(N/2:3*N/2,:,:);             % Discard outer half of Ryx
% Make time axis
t=(-N/2-1:N/2-1)/fs;

if nargout >= 3
    for d=1:D
        for r=1:R
            Gyx(:,d,r)=2*Syx(1:N+1,d,r);
        end
    end
end
if nargout == 4
    f=(0:fs/(2*N):fs/2)';
end