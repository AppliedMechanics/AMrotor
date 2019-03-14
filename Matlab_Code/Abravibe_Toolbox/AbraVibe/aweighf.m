function W = aweighf(f);
% AWEIGHF   Calculate A-weighting curve for A-weighting a spectrum
%
%           W = aweighf(f);
%
%           W       Frequency weighting curve (linear scale!)
%
%           f       Frequency values of W and the spectrum to A-weigh
%
% Calculates an array with (linear) A-weighting values for the frequencies
% in array f.
%
% Usage:    To A-weigh a linear spectrum XL (for example an octave band spectrum), do
%           La=XL.*aweighf(f);
%           where f is a vector with the frequencies for L(f).
%           To A-weigh a spectrum Lp in dB SPL (sound pressure level), do
%           Lpa=Lp+db20(aweighf(f),1);
%           To aweigh a power spectrum (for example a PSD), do
%           Gyya=Gyy.*aweighf(f).^2;

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2015-08-27 Corrected help function for call to db20
% This file is part of ABRAVIBE Toolbox for NVA

A1000=12200^2*1000^4/((1000^2 +20.6^2)*(1000^2 +12200^2)*sqrt((1000^2 +107.7^2))*sqrt((1000^2 +737.9^2)));
A=12200^2*f.^4./((f.^2 +20.6^2).*(f.^2 +12200^2).*sqrt((f.^2 +107.7^2)).*sqrt((f.^2 +737.9^2)));
W=A/A1000;
