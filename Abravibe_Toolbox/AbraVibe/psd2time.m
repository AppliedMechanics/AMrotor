function [y,t] = psd2time(P,f,N);
% PSD2TIME  Generate Gaussian random signal from PSD
%
%       [y,t] = psd2time(P,f,N)
%
%       y       Time data (column) vector
%       t       Time axis (assuming max(f)=fs/2)
%   
%       P       PSD, (single-sided) Power Spectral Density in (units)^2/Hz
%       f       Frequency axis for P. MUST start with 0 Hz and have constant increment.
%       N       Number of samples in y (default = length(P))
%
% This function is based on an inverse FFT and thus limited by the possible
% size of the IFFT. The RMS of y is equal to the RMS of P.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Check that frequencies from zero are included
if f(1) ~= 0
    error('PSD must be defined down to zero Hertz')
end

% Assume sampling frequency is 2*max(f)
fs=2*f(end);
deltaf=f(2)-f(1);

% Calculate RMS level of P before scalings
R=sqrt(deltaf*sum(P));

if nargin == 3          % Interpolate P up to length N/2+1
    newx=linspace(f(1),f(end),ceil(N/2)+1);
    P=interp1(f,P,newx,'linear','extrap');
    f=newx(:);
end
P=P(:);
A=sqrt(P);
    
% Create random phase evenly distributed in [-pi,pi]
phi=2*pi*(rand(length(A),1)-0.5);

% Produce double sided amplitude, if f is not already double sided
if min(f) >= 0
    A=[A(1); 0.5*A(2:end); 0.5*A(end-1:-1:2)];
    phi=[phi; -phi(end-1:-1:2)];
%     f=[-f(end-1:-1:2); f];
end

% y=2*sqrt(fs*length(A))*real(ifft(A.*exp(j*phi)));
y=sqrt(2*fs*length(A))*real(ifft((A.*exp(j*phi))));

% Scale time signal to same RMS as PSD
y=R/std(y)*y;

% Time axis if requested
if nargout == 2
    t=makexaxis(y,1/fs);
end