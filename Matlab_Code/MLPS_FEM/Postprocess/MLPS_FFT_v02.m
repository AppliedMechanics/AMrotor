function [f,Y_norm] = MLPS_FFT_v02(y,t)
%% BESCHREIBUNG %%

%FFT-Transformation und Analyse eines Signals

% Johannes Maierhofer
% 21.06.02016

%% ANLEITUNG %%

% y = Ortsvektor
% t = Zeitvektor

%% Parameter für FFT
NFFT = length(t);                   % AnzahlMessungen 
Fs = NFFT/t(NFFT);                  % Sampling frequency   
%% FFT
y_flat = detrend(y);                % Lineare Veränderungen und Offsets aus dem Signal filtern!
Y = fft(y_flat,NFFT)/NFFT;               %FFT
Y_norm = 2*abs(Y(1:floor(NFFT/2)+1));      %Normierte Amplitude
f = Fs/2*linspace(0,1,floor(NFFT/2)+1);    %Plot über Frequenz: Fs/2 = max. darstellbare Frequenz multipliziert mit linespace sorgt für einen Frequenz-
                                    %Vektor von 0 Hz bis Max Hz mit gleich langen Abschnitten               
%% Plot single-sided amplitude spectrum.

% figure
% plot(f,Y_norm) 
% title('Single-Sided Amplitude Spectrum of y')
% xlabel('Frequency (Hz)')
% ylabel('|y|')

%xlim([0,210])
%ylim([0,10])
% grid on

end
