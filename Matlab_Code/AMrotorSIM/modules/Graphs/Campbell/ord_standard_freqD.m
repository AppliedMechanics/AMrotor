clear all force;

% Create once test signals

[Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectrogram using as abscissa the time and for the ordinate
% not the frequency, but the current frequency divided by
% the rotational speed in revolutions per second (so called 
% 'Order'. This means that all components of the signals
% (higher orders) which are directly dependent of the rotation
% speed will be normalize to fixed ratios (1= static unbalance,
% 2= dynamic unbalance, 3-5-7 maybe the 'rough' sound of your engine etc.
% 12.56-15.91 could be a rolling bearing or gear before failure

nfft        = 2048;
noverlap    = floor(0.5*nfft);
window      = hanning(nfft);
maxOrderToUse = 50; % For Display and Interpolation

[B,F,T] = specgram(signal,nfft,Fs,window,noverlap);

% Improvement: rot speed in the middle of a fft window,
% not at the beginning as before:
idxnT   = round((T*Fs+1));
rpsTmp  = rpstheo(idxnT)'; 
rpsTmp  = (rpsTmp+[rpsTmp(2:end);rpsTmp(end)])/2; 

% Method 1:
% Fast calculation without interpolation, but 
% slow graphic display using 'surface' with 3 matrices:

Tn     = repmat(T.',size(B,1),1);
Fn     = repmat(F,1,size(B,2));
rpsTmpfield = repmat(rpsTmp.',size(B,1),1);

OrderF = Fn./rpsTmpfield; 

figure('Color',[1 1 1]);
surface(Tn,OrderF,20*log(abs(B)));
shading('interp');
set(gcf,'Renderer','zbuffer');
set(gca,'Ylim',[0 maxOrderToUse]); % set appropriate scaling manually
set(gca,'Color',[1 1 1]);
set(gca,'YDir','normal');
set(gca,'Layer','top');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
title('Order Spectrogram (Time as Abscissa, nonuniform mesh)');
xlabel('Time [s]');
yLabel('Order [Hz(Signal)/RPS(shaft)]');
%axis tight;


% Then you may Interpolate the data for further procesing
% The start and end positions my be linspace(0,max(OrderF(:)),nfft)
% but this is not good if you have very small speeds as the order
% number will become infinity...

% Interpolation bounds, respectively to time and order #:
% Interpolation only in F/O axis. No time interpolation.
% Fast and easy. See second algorithm below
Tstart = 0;
Tend   = t(end);
Ostart = 0;
Oend   = 50;%maxOrderToUse;
ONval  = 512;

[nil,Tstartidx]  = findnearest(T,Tstart);
[nil,Tendidx]    = findnearest(T,Tend);

OI = linspace(Ostart,Oend,ONval)';
TI = T([Tstartidx:Tendidx]);
BI = zeros (length(OI),Tendidx-Tstartidx);

for FFTcntr = [Tstartidx:Tendidx]
   signalntmp = interp1(OrderF(:,FFTcntr),B(:,FFTcntr),OI,'linear');
   BI([1:end],FFTcntr) = signalntmp(:);
end

figure('Color',[1 1 1]);
imagesc(TI,OI,20*log(abs(BI)));

title('Order Spectrogram (Standard, interp. frequency to uniform mesh, t remains)');
set(gca,'YDir','normal');
set(gca,'Box','on');
set(gca,'Layer','top');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Time [s]');
yLabel('Order Number');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional method to do full 2D Resampling
% Very slow... But you can use imagesc now to display very fast!
% Interpolation bounds, respectively to time and order #:

Tstart = 0;
Tend   = t(end);
TNVal  = 512;
Ostart = 0;
Oend   = maxOrderToUse;
ONval  = 512;

[TI,OI] = meshgrid(linspace(Tstart,Tend,TNVal),linspace(Ostart,Oend,ONval));
BI = griddata(Tn,OrderF,B,TI,OI);
figure('Color',[1 1 1]);

imagesc(linspace(Tstart,Tend,TNVal),linspace(Ostart,Oend,ONval),20*log(abs(BI)));

title('Order Spectrogram (Standard, full interp using griddata)');
set(gca,'YDir','normal');
set(gca,'Layer','top');
set(gca,'Box','on');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Time [s]');
yLabel('Order Number');