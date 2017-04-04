% Create once test signal

[Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectrogram using as abscissa the  current
% RPS data (Campbell-Diagramm)

nfft        = 2048;
noverlap    = floor(0.5*nfft);
window      = hanning(nfft);

[B,F,T] = specgram(signal,nfft,Fs,window,noverlap);
%B(1,:)=0;                                       

% Improvement: Get the number of rev. in the middle of a fft window,
% not at the beginning as before:
rps   = rpstheo;                            
idx   = round((T*Fs+1)); % The indices of the start times and set
rpsT  = rps(idx);        % the Abscissa to the speed in RPS -> Campbell
rpsT  = (rpsT+[rpsT(2:end),rpsT(end)])/2;    

% We have here run-up and run-down in one measurement
% You may split in 2 seperate diagrams after determining
% the maximum rps values. Or like it's made here use
% negative values for run down:
[nil,midx]      = max(rpsT);        % Find the point where run-up ends and run-down starts
rpsT (midx:end) =-rpsT(midx:end);   % Flip the data for run-down to the left
B(:,midx-1:midx)= NaN;              % Create a gab in the middle  

figure('Color',[1 1 1]);
ax1=axes;
surface(rpsT,F,20*log(abs(B)));
shading('interp');
set(gcf,'Renderer','zbuffer');
title('Spectrogram (RPS Speed as Abscissa, Campbell-Diagramm)');
xlabel('Run Down <---    RPS [1/s]    ---> Run Up');
yLabel('Frequency [Hz]');
axis tight;
set(ax1,'Layer','top');
set(ax1,'YDir','normal');
set(ax1,'Box','on');
set(ax1,'XMinorTick','on');
set(ax1,'YMinorTick','on');
set(ax1,'YLim',[0,1800]);




