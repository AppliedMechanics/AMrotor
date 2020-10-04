% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [f,Y,AP] = FFT_Data_Gesamt (X,fs)
% Carries out the FFT and provides the one sided amplitude spectrum for the Waterfall diagram
%
%    :param X: Data
%    :type X: vector
%    :param fs: Sampling rate
%    :type fs: double
%    :return: Frequency vector and amplitude (complex and absolut) f,Y,AP

%###INPUT
%   X       -   Datenvektor
%   fs      -   Samplefrequenz
%   fsrc    -   Gesuchte Frequenz 
%   schalter-   mehrere Graphen in einen Plott = 1

%###OUTPUT
%   Y          -   Komplexe  Koeffizienten von X
%   YsrcFFT    -   Komplexer  Koeffizient für gesuchte Frequenz "fsrc" genmäß FFT
%   YsrcAFFT   -   Komplexer  Koeffizient für gesuchte Frequenz "fsrc" genmäß AFFT

% DFT
Y = fft(X);
L = length(X);

%Normierung
Y = 2*Y/L;

%Wegschneiden der negativen Frequenzen
if (floor(L/2)~=L/2)
    Y = Y(1:end-1);
end

Y = Y(1:floor(L/2)+1);

%Berechung des Frequenzvektors 
f = (fs/L)*(0:(L/2));
AP = abs(Y);

end

