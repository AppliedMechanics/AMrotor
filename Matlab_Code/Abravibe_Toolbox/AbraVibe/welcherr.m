function Eps_r = welcherr(win,O,K)
%WELCHERR   Random error in PSD estimate with Welch's method 
%
%           Eps_r = welcherr(win,O,K)
%
%           Eps_r    Normalized random error of PSD estimate
%
%           win      Window vector, for example hann(512) 
%           O        Overlap between blocks in percent
%           K        number of averages in PSD calculation
%
% This function computes the random error in PSDs estimated with overlap
% according to Welch 1967, see inside file for reference.
%
% Example: Eps_r = welcherr(hann(512),50,199)
%    Gives the random error Eps_r = 0.0728, which means that 199 averages with
%    50% overlap and Hanning window correponds to 1/0.0728^2 = 189
%    independent (nonoverlapping) averages. Note that this corresponds to
%    100 independent segments of data, plus 99 overlapping segments
%    (because the 100th block will be half way outside the data).

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


% References
% Welch, Peter (1967), The Use of Fast Fourier Transform for the Estimation of
% Power Spectra: A Method Based on Time Averaging Over Short, Modified
% Periodograms, IEEE Trans. On Audio and Electroacoustics, AU-15(2), pp
% 70-73
% where the formula for the random error (or variance, its square) is given
%
% Brandt, Anders: "Noise and Vibration Analysis: Signal Analysis and
% Experimental Procedures," Wiley 2011. ISBN: 13-978-0-470-74644-8,
% where normalized random error is defined

% Copyright 2011, Anders Brandt

N=length(win);                     % Blocksize for calculation
D=round(N*(1-O/100));              % Welch used the DELAY in samples

w = zeros(3*N,1);
w(1:N) = win;
rho = zeros(K,1);

% Calculate rho(q)
q = 1;
while q*D < N
    wn = zeros(3*N,1);
    wn(q*D+1:q*D+N) = win;
    rho(q) = sum(w.*wn)/sum(w.*w);
    rho(q) = rho(q)^2;
    q = q+1;
end

% Sum up (1 + 2*sum(rho(q)))
V = 1;
for q = 1:K-1
    V = V + 2*(K-q)/K*rho(q);
end

% Normalized random error is square root of variance
Eps_r = sqrt(V/K);

