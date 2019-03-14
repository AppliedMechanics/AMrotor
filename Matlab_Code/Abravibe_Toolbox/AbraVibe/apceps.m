function [cp, tau] = apceps(Gxx,f)
% APCEPS    Calculate power cepstrum of single-sided autospectrum
%
%        [cp, tau] = apceps(Gxx,f)
%
%        Gxx        Single-sided autospectrum
%          f        Frequency axis for Gxx
%
%         cp        Power cepstrum
%        tau        Time lag axis for cp

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


N=length(Gxx);

Sxx=fnegfreq(Gxx,'fft',f);

cp=ifft(log(Sxx));
cp=cp(1:N);
cp(1)=0;
fs=2*f(end);
tau=makexaxis(cp,1/fs);