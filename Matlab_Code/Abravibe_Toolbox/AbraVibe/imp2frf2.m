function [H,f,C,Tff] = imp2frf2(x,y,fs,N,TrigIdx,DIdx,FWinLength,ExpWinPar,Plot)
% IMP2FRF  Calculate FRF(s) from impact time data recording
%
%        [H,f,C,Tff] = imp2frf2(x,y,fs,N,TrigIdx,DIdx,FWinLength,FWinLength,ExpWinPar,Plot)
%
%           H           Frequency response(s), N/2+1-by-D
%           f           Frequency axis, N/2+1-by-1
%           C           Coherence function(s), N/2+1-by-D. Empty if only
%                       one average
%           Tff         Transient spectrum of force signal
%
%           x           Force vector
%           y           Response signal(s) in D column(s)
%           fs          Sampling frequency
%           N           Block size for FFT
%           TrigIdx     Trigger indeces from imptrig
%           DIdx        Double impact indeces from imptrig
%           FWinLength  Force window in percent of N
%           ExpWinPar   End value of exponential window in percent
%           Plot        Logical variable, if Plot=1,a result plot is produced
%
% This is an internal, special version of imp2frf for use in IMPSETUP, to
% allow for one time selection of impacts for subsequent analysis rounds.
% It does not prompt for user selection but uses predefined trigger events.
%
% See also IMPSETUP IMPMASSCAL IMPPROC IMPTRIG AFORCEW AEXPW
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% disp('inside imp2frf2, TrigIdx is...')
% disp(TrigIdx)

% Find lengths and dimensions
D=length(y(1,:));
if length(x(1,:)) > 1
    x=x(:,1);
end
if length(y(1,:)) > 1
    D=length(y(1,:));       % Number of responses
end

% Use the selected impacts to calculate FRF etc for each response (column)
% in y
yin=y; clear y
for k = 1:D
    y=yin(:,k);
    L=N/2+1;
    Tyf=zeros(L,1);
    Tyy=zeros(L,1);
    Tff=zeros(L,1);
    fw=aforcew(N,FWinLength);
    ew=aexpw(N,ExpWinPar);
    for n=1:length(TrigIdx)
        F=x(TrigIdx(n):TrigIdx(n)+N-1);
        F=F-F(1);
        F=F.*fw.*ew;
        Ff=fft(F);
        Ff=Ff(1:L);
        Y=y(TrigIdx(n):TrigIdx(n)+N-1);
        Y=Y.*ew;
        Yf=fft(Y);
        Yf=Yf(1:L);
        Tyf=Tyf+(Yf.*conj(Ff));
        Tyy=Tyy+abs(Yf).^2;
        Tff=Tff+abs(Ff).^2;
    end
    H(:,k)=Tyf./Tff;
    f=(0:fs/N:fs/2);
    C(:,k)=abs(Tyf).^2./Tff./Tyy;
    Tff(:,k)=Tff/n/fs;               % Transient average spectrum
    if exist('Plot','var')
        if Plot
            figure
            subplot(3,1,1)
            semilogy(f,abs(H))
            ylabel('FRF')
            subplot(3,1,2)
            plot(f,C)
            ylabel('Coherence')
            subplot(3,1,3)
            semilogy(f,Tff)
            ylabel('Force Spec.')
            xlabel('Frequency [Hz]')
        end
    end
end

if std(C) == 0      % Indicates only one average has been used
    C=[];
end