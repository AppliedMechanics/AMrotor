function [f,Y] = perform_fft(t,y)

L = length(y);            % Length of signal
Fs = 1/(t(2)-t(1));       % Sampling frequency

NFFT = L;%2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1)';

Y = 2*abs(Y(1:NFFT/2+1));
Y(1) = Y(1)/2;

end