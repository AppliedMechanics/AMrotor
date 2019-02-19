function [b,a] = noctfilt(n,fc,fs)
%NOCTFILT Calculate filter coefficients for fractional octave band filter
%
%           [b,a] = noctfilt(n,fc,fs)
%
%           b       Filter coefficients as used by, e.g., FILTER command
%           a       Ditto. Can be one or more rows, see fc below.
%
%           n       Fractional octave number (for 1/n octave filter)
%           fc      Center frequency (frequencies). If length > 1, b,a will
%                   be rows in matrices with one row per center frequency.
%           fs      Sampling frequency 
%
% NOTE n must be 1, 2, 3, 6, 12, 24, or 48
%
% This command produces coefficients for a filter that conforms with 
% IEC 61260:1995, and ANSI S1.11-2004, if possible. If the sampling
% frequency is unsuitable, so that the filter shape is not within the
% limits, a warning is issued.
%
% Suitable ratios for fs/fc is approximately 5 < fs/fc < 500.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2013-03-18 Changed to fourth-order Butterworth and allowed
%                         1/48 octaves
% This file is part of ABRAVIBE Toolbox for NVA

% Check that the requested n is supported
N=[1 2 3 6 12 24 48];
if ~ismember(n,N)
    error('Unsupported fractional octave number');
end

%G=2;               % Base two definition
G=10^.3;            % Base ten definition
OctRatio=G^(0.5/n);
fl = fc/OctRatio;
fh = fc*OctRatio;
fnyq = fs/2;                % Nyquist frequency for BUTTER command

[b,a] = butter(4,[fl/fnyq fh/fnyq]);  % Changed to fourth order 2013-03-18

% Check that filter corresponds to IEC/ANSI standard, or issue warning
% The filter shape is checked in freq. range fc/5 < f < 5*fc
[Lu,Ll,f]=noctlimits(n,fc);         % Calculate limits
[Hf,ff]=freqz(b,a,10000,fs);         % Filter frequency response, 10000 values; changed 2013-03-18
Hf=Hf(2:end);                       % Remove zero frequency
ff=ff(2:end);
Lu=interp1(f,Lu,ff,'linear','extrap');                % Interpolate fu onto ff axis
Ll=interp1(f,Ll,ff,'linear','extrap');
idx=find(ff > fc/5  & ff < 5*fc & Lu > -75);          % Added Lu boundary 2013-03-18
if ~isempty(find(db20(Hf(idx))>Lu(idx))) | ~isempty(find(db20(Hf(idx))<Ll(idx)))
    warning('Filter shape does not conform with IEC/ANSI standard. Resample data to different sampling frequency!')
    figure
    semilogx(ff(idx),Ll(idx),ff(idx),Lu(idx),ff(idx),db20(Hf(idx)))
end
