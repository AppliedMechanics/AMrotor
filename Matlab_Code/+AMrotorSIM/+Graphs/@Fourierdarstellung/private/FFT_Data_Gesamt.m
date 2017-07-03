function [f,Y,AP] = FFT_Data_Gesamt (X,fs)
%F�hrt die DFT f�r den Datenvektor I aus und plottet das einseitige
%Amplitudenspektrum

%###INPUT
%   X       -   Datenvektor
%   fs      -   Samplefrequenz
%   fsrc    -   Gesuchte Frequenz 
%   schalter-   mehrere Graphen in einen Plott = 1

%###OUTPUT
%   Y          -   Komplexe  Koeffizienten von X
%   YsrcFFT    -   Komplexer  Koeffizient f�r gesuchte Frequenz "fsrc" genm�� FFT
%   YsrcAFFT   -   Komplexer  Koeffizient f�r gesuchte Frequenz "fsrc" genm�� AFFT

% DFT
Y = fft(X);
L = length(X);

%Normierung
Y = 2*Y/L;

%Wegschneiden der negativen Frequenzen
if (floor(L/2)~=L/2)
    Y = Y(1:end-1);
end

Y = Y(1:L/2+1);

%Berechung des Frequenzvektors 
f = (fs/L)*(0:(L/2));
AP = abs(Y);

end

