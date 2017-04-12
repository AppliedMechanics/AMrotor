clear all force;

% Create once test signals

[Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;

nfft        = 2048;
noverlap    = floor(0.5*nfft);
window      = hanning(nfft);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Order spectrogram by using specgram in the angular domain
%
% This function was created to resample the signal not in the frequency domain after
% calculating the spectrogram, but in the angular domain. 
% We have to take care to the fact that the angle which the shaft rotates in a fixed 
% time interval is proportional to the angular velocity. 
% To get the orders we have to assume a constant angular speed. This means that
% we can obtain this by stretching the time axis where the speed is high and compress
% it, where the speed is low.
% In other words: if we have constant ang. vel. we get a straight line starting
% at the origin in a cumulative rotation angle over time diagram and a straight
% horizontal line in the spectrogram. If we vary speed, we get no longer a straight
% line, but curved on for the cumulated angle vs. time and also a modulation in the
% spectrogram frequencies by the angular velocity or (=2*pi*rouns per second).
% So the task is to define a new time axis, which stretches the cumulated angle vs. time
% diagram locally by the use of the ang. vel. to get a straight line again!
% (The integration of the ang. vel. along the time axis is the total rotation angle)


rps   = rpstheo;
phi   = cumsum(2*pi*rps/Fs);

%You may specify a new signal length- but be aware of undersampling:
Nphin = length(phi)*1; 
% Warning:
% Undersampling may also occur at low speeds, but only signal components which
% depend not on the speed are effected.
% You can check this visually if mirroring of hyberbolic curve segments on the 
% upper bound of the plot is seen. If you specify a longer signal length than
% before, oversampling will reduce this risk!

phin    = linspace(0,phi(end),Nphin)';   % Interpolate
signaln = interp1(phi,signal,phin,'linear');

% To create the axes we have to know that we would have reached the total 
% cumulative rotation angle at the end of the test, if we'd used a constant
% speed over the same nonlinear scaled time:

omegan  = phi(end)/t(end);
% So we get a new sampling rate in the angular domain (Samples per rad, not
% Samples per second)
PHIs = length(signal)/phi(end);

[Bt,OrderPhiT,PHIt] = specgram(signaln,nfft,PHIs,window,noverlap); % B = Matrix mit komplexen FFTS, F = Frequenzachse, T = Zeiten zu den FFTs  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a Order Diagramm with time as abscissa
% (we need some data from above)

% Create interpolated time and rps axis
% Looks a little bit confusing, but think of the fact
% that the time must be streched to fit a linear increase
% of angle (if the angular speed is not constant)

OrderRps = OrderPhiT*2*pi;
% For Campbell Order Spectrogram (i.e. orders over rps, 
% could also be seen as a kind of unbalance over the speed) 
% we have to make an abscissa representing the current speed

rpsn  = interp1(phi,rps,phin,'linear'); % interpolate to finer time & angle domain
idx   = round((PHIt*PHIs+1)); % get the start index for every single FFT 
rpsnT = rpsn(idx);

% We have here run-up and run-down in one measurement
% You may split in 2 seperate diagrams after determining
% the maximum rps values. Or like it's made here use
% negative values for run down:
[nil,midx]       = max(rpsnT);          % Find the point where run-up ends and run-down starts
rpsnT (midx:end) =-rpsnT(midx:end);     % Flip the data for run-down to the left
Bt(:,midx-1:midx) = NaN;                 % Create a gab in the middle  

figure('Color',[1 1 1]);
surface(rpsnT,OrderRps,20*log(abs(Bt)));
shading('interp');
set(gcf,'Renderer','zbuffer');
title('Order Spectrogram (Orders vs. RPS, Order-Campbell-Diag.)');
xlabel('Run Down <---    RPS [1/s]    ---> Run Up');
yLabel('Order No.');
axis tight;
set(gca,'YDir','normal');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'Layer','top');
set(gca,'Box','on');
set(gca,'YLim',[0 50]);

