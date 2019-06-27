function fcs = noctfreqs(n, fmin, fmax)
% NOCTFREQS     Compute the exact midband frequencies for a 1/n octave analysis
%
%       fcs = noctfreqs(n, fmin, fmax)
%
%       fcs         Exact center frequencies for 1/n octaves, according to
%                   IEC 61260:1995, and ANSI S1.11-2004 standards.
%
%       n           Fractional octave number
%       fmin        Approximate lower cutoff frequency of lowest 1/n octave band
%       fmax        Approximate upper cutoff frequency of highest 1/n octave band
%
% See also NOCTFILT, SPEC2NOCT
%

% Decide if n is odd or even
IsOdd=mod(n,2);
% Standard parameters
G=10^0.3;       % Base ten (preferred)

% Calculate minimum and maximum approximate center frequencies
fcmin=fmin*G^(1/2/n);
fcmax=fmax*G^(-1/2/n);

% Compute min and max x
if IsOdd
    xmin=ceil(30+n/0.3*log10(fcmin/1000));
    xmax=floor(30+n/0.3*log10(fcmax/1000));
    x=[xmin:xmax];
    fcs=1000*G.^((x-30)/n);
else
    xmin=ceil(0.5*(59+n/0.3*log10(fcmin/1000)));
    xmax=floor(0.5*(59+n/0.3*log10(fcmax/1000)));
    x=[xmin:xmax];
    fcs=1000*G.^((2*x-59)/n);
end


