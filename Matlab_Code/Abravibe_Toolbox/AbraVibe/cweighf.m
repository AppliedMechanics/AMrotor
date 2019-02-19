function W = cweighf(f);
% CWEIGHF   Calculate C-weighting curve for C-weighting a spectrum
%
%           W = cweighf(f);
%
%           W       Frequency weighting curve (linear scale!)
%
%           f       Frequency values of W and the spectrum to C-weigh
%
% Calculates an array with (linear) C-weighting values for the frequencies
% in array f.
%
% Usage:    To C-weigh a linear spectrum L (for example an octave band spectrum), do
%           Lc=L.*cweighf(f);
%           where f includes the frequencies for L(f).
%           To C-weigh a spectrum in dB SPL (sound pressure level), do
%           Lpc=L+db20(cweighf(f),2e-5);

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

C1000=12200^2*1000^2/((1000^2 +20.6^2)*(1000^2 +12200^2));
C=12200^2*f.^2./((f.^2 +20.6^2).*(f.^2 +12200^2));
W=C/C1000;
