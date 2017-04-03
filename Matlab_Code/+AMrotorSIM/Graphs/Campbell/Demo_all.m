% % Signal and speed plot
% [Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;
% figure;
% plot(t,rpstheo);
% title('Rotations per second (RPS) vs. measure Time');
% xLabel('Time [s]');
% yLabel('RPS [1/s]');
soundsc(signal,Fs);

%Standard spectrogram:
spec_standard

% Spectrogram with turns as x-axis:
spec_turns

% Campbell Diagram with run-up run-down:
spec_campbell

% Order Analysis in the Frequency Domain 
% with interpolation:
ord_standard_freqD

% Order Analysis in the Angular Domain:
ord_angular_Dom

% Campbell order diagram
ord_campbell_angD


