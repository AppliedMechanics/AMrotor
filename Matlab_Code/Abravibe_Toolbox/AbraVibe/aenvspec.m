function [E,f] = aenvspec(x,fs,N,fc,B)
% AENVSPEC  Calculate envelope spectrum
%
%       [E,f] = aenvspec(x,fs,N,fc,B)
%
%       E       Envelop spectrum
%       f       Frequency axis for E
%
%       x       Time signal
%       fs      Sampling frequency for x
%       N       FFT blocksize
%       fc      center frequency of bandpass filter (optional)
%       B       Bandpass filter bandwidth

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23  
%          1.1 2012-01-15 Modified to work for Octave
% This file is part of ABRAVIBE Toolbox for NVA


if nargin == 3
    fc=0;
    B=0;
end

% Bandpass filter data if requested
if fc > 0
    flo=(fc-B/2)/(fs/2);
    fhi=(fc+B/2)/(fs/2);
    [b,a]=butter(4,[flo fhi]);
    if strcmp(checksw,'MATLAB')
        x=filtfilt(b,a,x);
    else
        x=filter(b,a,x);        % Octave does not cope with filtfilt here
    end
end

% Calculate Hilbert envelope
e=abs(hilbert(x));

% Calculate envelope spectrum from square of envelope
[E,f]=alinspec(e-mean(e),fs,ahann(N),1);
E(1:5)=0;
