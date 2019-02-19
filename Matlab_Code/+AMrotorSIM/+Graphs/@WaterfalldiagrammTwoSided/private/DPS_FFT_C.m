function [f,Y] = DPS_FFT_C (y,t)
%% BESCHREIBUNG %%

%FFT-Transformation und Analyse eines Signals
%% ANLEITUNG %%

% y = Ortsvektor
% t = Zeitvektor

%% Parameter für FFT
t = t - t(1);                       % Zeit beginnt bei 0s;
NFFT = length(t);                   % AnzahlMessungen 
Fs = 1/(t(2)-t(1));%NFFT/t(NFFT);                  % Sampling frequency   
%% FFT
Y = fft(y,NFFT)/NFFT;               %FFT
Y_norm = 2*abs(Y(1:floor(NFFT/2)+1));      %Normierte Amplitude
f = Fs/2*linspace(0,1,NFFT/2+1);    %Plot über Frequenz: Fs/2 = max. darstellbare Frequenz multipliziert mit linespace sorgt für einen Frequenz-
                                    %Vektor von 0 Hz bis Max Hz mit gleich langen Abschnitten 
Y = Y(1:floor(NFFT/2)+1);                            %Da hier zweiseitges Spektrum
end
