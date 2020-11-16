function [f,Y] = DPS_FFT_C (y,t)
% Carries out the FFT and provides the two sided amplitude spectrum for the Waterfall diagram
%
%    :param y: Data
%    :type y: vector
%    :param t: Time vector
%    :type t: vector
%    :return: Frequency vector and complex amplitude f,Y

% Licensed under GPL-3.0-or-later, check attached LICENSE file

%% BESCHREIBUNG %%

%FFT-Transformation und Analyse eines Signals
%% ANLEITUNG %%

% y = Ortsvektor
% t = Zeitvektor

%% Parameter f�r FFT
t = t - t(1);                       % Zeit beginnt bei 0s;
NFFT = length(t);                   % AnzahlMessungen 
Fs = 1/(t(2)-t(1));%NFFT/t(NFFT);                  % Sampling frequency   
%% FFT
Y = fft(y,NFFT)/NFFT;               %FFT
Y_norm = 2*abs(Y(1:floor(NFFT/2)+1));      %Normierte Amplitude
f = Fs/2*linspace(0,1,NFFT/2+1);    %Plot �ber Frequenz: Fs/2 = max. darstellbare Frequenz multipliziert mit linespace sorgt f�r einen Frequenz-
                                    %Vektor von 0 Hz bis Max Hz mit gleich langen Abschnitten 
Y = Y(1:floor(NFFT/2)+1);                            %Da hier zweiseitges Spektrum
end
