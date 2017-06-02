% Create once test signal

[Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectrogram using as abscissa the number of revolutions

nfft        = 2048;
noverlap    = floor(0.5*nfft);
window      = hanning(nfft);

[B,F,T] = specgram(signal,nfft,Fs,window,noverlap);
%B(1,:)=0;                                       

% Improvement: Get the number of rev. in the middle of a fft window,
% not at the beginning as before:
nRev  = cumsum(rpstheo)/Fs;                            
idx   = round((T*Fs+1)); % get the start angle for every FFT 
nRevT = nRev(idx);
nRevT = (nRevT+[nRevT(2:end),nRevT(end)])/2;    

figure('Color',[1 1 1]);
ax1=axes;
surface(nRevT,F,20*log(abs(B)));
shading('interp');
set(gcf,'Renderer','zbuffer');
title('Spectrogram (Turns as Abscissa bottom, Time top)');
xlabel('Turns (total) [1]');
yLabel('Frequency [Hz]');
axis tight;
set(ax1,'Layer','top');
set(ax1,'YDir','normal');
set(gca,'YLim',[0,1800]);

set(ax1,'XMinorTick','on');
set(ax1,'YMinorTick','on');
set(ax1,'Box','on');

% Create socond axis with time
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none');

set(ax2,'YColor',get(gcf,'Color'));
set(ax2,'Layer','top');

set(ax2,'YLim',get(ax1,'YLim'));
set(ax2,'YTick',get(ax1,'YTick'));
set(ax2,'TickDir','out');

Pos = get(ax1,'Position');
set(ax2,'Position',[Pos(1),Pos(2),Pos(3),Pos(4)-0.06]);

% combine labeling of ax1 and ax2
set(ax2,'XLim',[min(T),max(T)]);
l=get(ax1,'XTick');
l = [min(nRev),l,max(nRev)];
set(ax2,'XTick',linspace(min(T),max(T),length(l)));
[valuevec,idxvec]=findnearest(nRev,l);
labels = floor(t(idxvec)*10)/10;
set(ax2,'XTickLabels',labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create spectral plot over one rotation by
% sorting and averaging all FFT lines.
% Needs data from above!

AngularRes = 36; % 360 lines per 1 revolution
angAxis    = linspace(0,360,AngularRes);

Bang       = zeros(size(B,1),AngularRes)*NaN;
wrapphi    = mod(nRevT,1)*360;

for angcntr = 1:AngularRes-1

    angidx  = find(wrapphi>=angAxis(angcntr) & wrapphi<=angAxis(angcntr+1));
    BMean   = abs(B(:,angidx));
    Bang(:,angcntr) = mean(BMean,2);
    
end
figure ('Color',[1 1 1]);
surface(angAxis,F,20*log(Bang));
shading('interp');
set(gcf,'Renderer','zbuffer');
title('Spectrogram vs. Angle');
xlabel('Angle [Deg °]');
yLabel('Frequency [Hz]');
axis tight;
set(ax1,'Layer','top');
set(ax1,'YDir','normal');
set(gca,'YLim',[0,1800]);