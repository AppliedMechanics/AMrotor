function [L,f] = spec2noct(Gxx,f,n,Type,win)
%SPEC2NOCT   Calculate 1/n octave spectrum from an FFT spectrum
%
%           [L,f] = spec2noct(Gxx,f,n,type)
%
%           Gxx     Spectrum based on FFT (linear spectrum or PSD)
%           f       Frequency axis for Gxx. MUST BE [0:df:fs/2]
%
%           n       Fractional octave number (for 1/n octave filter)
%           type    'lin' or 'psd'
%           win     Vector with time window used for spectrum, only for Type='lin'
%                   Note: Does not need to be same length as Gxx and f
%
% NOTE n must be 1, 2, 3, 6, 12, or 24
% 
% This command uses coefficients for filters according to IEC 61260:1995, 
% and ANSI S1.11-2004. HOWEVER, DUE TO LACKING FREQUENCY RESOLUTION, THE
% FILTERS MAY NOT CONFORM TO THE STANDARDS! If you wish to know, edit the
% file, and remove the 'warning off" at the beginning of the code.
%
% The lowest 1/n octave included in L is the one where there are 3 
% frequency bins inside the 1/n octave width.
%
% SEE ALSO    NOCTFILT, NOCTFREQS

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2017-10-07 First official release. 
% This file is part of ABRAVIBE Toolbox for NVA

warning off

if nargin == 4 & strcmp(upper(Type),'LIN')
    error('You must specify window for Type=''lin''!')
end
% Check that lowest frequency in f is zero
if f(1) ~= 0
    error('First frequency in f must be zero!')
end

% Check that the requested n is supported. You can add more possibilities
% here, like 6, 12, 24
N=[1 3];
if ~ismember(n,N)
    error('Unsupported fractional octave number');
end
 

% G=2;                    % Base two definition
G=10^.3;                % Base ten definition
OctRatio=G^(0.5/n);
fs=2*f(end);            % ONLY works for spectra with f=[0,fs/2]
df=f(2)-f(1);
Bratio=G^(1/2/n)-G^(-1/2/n);  % bandwidth ratio, i.e. B=fc*Bratio for each octave band
% Compute the lowest 1/n octave band, as the band with 3 frequency bins
% within the octave band. Then compute the lower cutoff freq. of this band
fcmin=3*df/Bratio;
fmin=fcmin*G^(-1/2/n);

% Now compute all exact center frequencies for the octave bands
fcs=noctfreqs(n,fmin,fs/2/1.15);
for k=1:length(fcs);
    fc=fcs(k);
    fl = fc/OctRatio;
    fh = fc*OctRatio;
    fnyq = fs/2;                % Nyquist frequency for BUTTER command
    % Fourth (since rev 1.1) order butterworth bandpass filter coefficients
    [b,a] = butter(3,[fl/fnyq fh/fnyq]);  
    % Check that filter corresponds to IEC/ANSI standard, or issue warning
    % The filter shape is checked in freq. range fc/5 < f < 5*fc
    [Lu,Ll,ff]=noctlimits(n,fc);         % Calculate limits
    Hf=freqz(b,a,f,fs);
    Lu=interp1(ff,Lu,f,'linear','extrap');                % Interpolate fu onto ff axis
    Ll=interp1(ff,Ll,f,'linear','extrap');
    idx=find(f > fc/5  & f < 5*fc & Lu > -75);          % Added Lu boundary 2013-03-18
    if ~isempty(find(db20(Hf(idx))>Lu(idx))) | ~isempty(find(db20(Hf(idx))<Ll(idx)))
        warning(['nonconfirming octave: ' num2str(fc) ' Hz'])
    end
%     semilogx(f,db20(Hf),f,Ll,f,Lu)
%     title(['fc = ' num2str(fc)])
%     pause
    if strcmp(upper(Type),'LIN')
        ENBW=winenbw(win);
        St=(abs(Hf).*Gxx).^2;
        L(k)=sqrt(sum(St)/ENBW);
    else
        St=(abs(Hf).^2).*Gxx;
        L(k)=sqrt(df*sum(St));
    end
end
f=fcs;

warning on