function [Tx,f] = atranspec(x,fs);
%ATRANSPEC Calculate (linear) transient spectrum
%
%           [Tx,f] = atranspec(x,fs)
%
%           Tx          PSD of time signal x
%           f           Frequency vector for Tx, N/2+1-by-1
%
%           x           Time data in column vector(s). If more than one
%                       column, each column is treated separately
%           fs          Sampling frequency for x
%
%           D           Number of vectors (columns) in x
%
% Tx equals the square root of energy spectral density, ESD. Note
% especially that Tx is double-sided, although only calculated for positive
% frequencies, i.e. Tx NOT multiplied by 2 for k > 0. The reason for this
% is to allow pulses with a DC value to have a continuous spectrum.
%
% See also apsdw alinspec aexpw

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters

% Set up parameters
[N,D]=size(x);

% Make sure N is even
if mod(N,2) ~= 0
    N=N-1;
end

% Calculate transient spectrum of each column in x
T=zeros(N/2+1,D);
for d = 1:D
    xt=x(:,d);
    Tt = 1/fs*abs(fft(xt));
    Tx(:,d) = Tt(1:N/2+1);
end
f=(0:fs/N:fs/2)';

