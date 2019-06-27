function [Ryx,t,Gyx,f] = axcorrp(x,y,fs,N)
% AXCORRP      Scaled cross-correlation between x (input) and y (output)
%              For positive lags
%
%       [Ryx,t,Gyx,f] = axcorr(x,y,fs,N)
%
%       Ryx         Scaled cross correlation, N-by-D-by-R
%       t           Time lag vector
%       Gyx         Single-sided PSD (Note! No window!), 2N-by-D-by-R
%       f           Frequency axis for Gyx
%
%       x           Input signal(s), with time data in R column(s)
%       y           Output signal(s), with time data in D columns
%       fs          Sampling frequency
%       N           Length of correlation function
%
% This function estimates unbiased cross correlation for positive lags only.
% Use axcorrp(x,x,...) to produce autocorrelation.
% For N~=0, calculations are made using Welch method on zero padded data 
% with length 2N, so spectra are twice as large as from, e.g., APSDW.
% For N=0, the periodogram based approach is used, i.e. the correlation is
% computed as a convolution produced by making FFTs of the entire data, with 
% zero padding by as many zeros as the length of x, multiplying the
% spectra, and going back to time domain. Unbiased estimates are then
% produces by compensating for the triangular window.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
% This file is part of ABRAVIBE Toolbox for NVA

if N == 0
    N=length(x(:,1));
end

% Set up parameters
df=fs/(2*N);                        % Blocks augmented by N zeros
ovlp=N; %floor(N/2);
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
        X=fft(x_tmp,2*N)/(2*N);                 % Zero-padded fft %%%%%%%%%%%%% CHANGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Y=fft(y_tmp,2*N)/(2*N);                 % Zero-padded fft %%%%%%%%%%%%% CHANGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% Go through Syx and calculate corresponding Ryx
Ryx=zeros(N,D,R);
n=(0:N-1)';
w=N./(N-n);
for r = 1:R
    for d = 1:D
        Rt=ifft(Syx(:,d,r));
        Rt=w.*Rt(1:N)*fs;
        Ryx(:,d,r)=Rt;
    end
end
t=makexaxis(Ryx,1/fs);

if nargout >= 3
    for d=1:D
        for r=1:R
            Gyx(:,d,r)=Syx(1:N+1,d,r);          % Positive frequencies
            Gyx(2:end,d,r)=2*Gyx(2:end,d,r) ;   % Single-sided scaling
        end
    end
end
if nargout == 4
    f=(0:fs/(2*N):fs/2)';
end