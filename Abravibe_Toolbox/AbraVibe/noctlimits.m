function [Lu,Ll,f] = noctlimits(n,fc);
%NOCTLIMITS Calculate IEC/ANSI limits for fractional octave filter
%
%           [Lh, Ll,f] = noctlimits(n,fc)
%
%           Lh          Upper limit in dB, in column vector
%           Ll          Lower limit in dB, in column vector
%           f           Frequency axis in Hz for Lh and Ll, in column
%                       vector(s). If fc contains several frequencies, each
%                       column in f corresponds to the same column in fc.
%
%           n           Fractional octave number, 1 for full octaves, 3 for 1/3 oct. etc...
%           fc          Center frequency of 1/n octave filter. can be a row
%                       or a column vector for calculating limits for several bands
%
% This function calculates upper and lower limits of a fractional octave
% band as specified in the standards IEC 61260:1995, and ANSI S1.11-2004.
% Particularly note that the limits are always the same values, only the
% frequencies change depending on the chosen center frequency/frequencies.
% Thus, Lh and Ll are always single columns, even if several center
% frequencies fc are calculated.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Filter class 0 is used, as there is no reason in MATLAB to make the accuracy
% less than the best.
% Base ten is used (the standard gives you the option of base ten or base
% two).

% G=10^(3/10);    % This is the constant for base ten definition
G=2;    % This is the constant for base two definition

% Calculate base frequency break points
OmegaUpper=[G^(1/8) G^(1/4) G^(3/8) G^(1/2)*(1-1e-11) G^(1/2) G G^2 G^3 G^4]-1;
OmegaUpper=1+((G^(1/2/n)-1)/(sqrt(G)-1))*OmegaUpper;

if length(fc) == 1
    f=fc*[fliplr(1./OmegaUpper) 1 OmegaUpper]';
else
    f=zeros(19,length(fc));
    for n=1:length(fc)
        f(:,n)=fc(n)*[fliplr(1./OmegaUpper) 1 OmegaUpper]';
    end
end

% Create limits
Lu=[-75 -62 -42.5 -18 -2.3 .15 .15 .15 .15 .15 .15 .15 .15 .15 -2.3 -18 -42.5 -62 -75]';
Ll=[-inf -inf -inf -80 -4.5 -4.5 -1.1 -.4 -.2 -.15 -.2 -.4 -1.1 -4.5 -4.5 -80 -inf -inf -inf]';
