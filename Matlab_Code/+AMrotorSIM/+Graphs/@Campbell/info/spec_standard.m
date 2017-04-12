% Create once test signal

[Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard spectrogram using for abscissa the time

nfft        = 2048;
noverlap    = floor(0.5*nfft);
window      = hanning(nfft);

% B = Matrix with FFT's, F = frequency axis, T = time axis:
[B,F,T] = specgram(signal,nfft,Fs,window,noverlap);   
%B(1,:)=0;   % Remove constant part, only for a nice view

figure('Color',[1 1 1]);

imagesc(T,F,20*log(abs(B)));
title('Spectrogram (Standard)');
set(gca,'YDir','normal');
set(gca,'Layer','top');
set(gca,'Box','on');
set(gca,'Layer','top');
set(gca,'YLim',[0,1800]);
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Time [s]');
yLabel('Frequency [Hz]');