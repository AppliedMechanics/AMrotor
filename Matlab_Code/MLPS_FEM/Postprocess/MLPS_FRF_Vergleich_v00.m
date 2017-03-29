%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLPS
% Stelle Frequenzübertragungsfunktionen auf
%
% Johannes Maierhofer, Christian Wagner
% 05.07.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *Datenstruktur - Übertragungsfunktion*
%
% frf(1) = [s] Zeit
% frf(2) = [m] Anregung x1 (Global Lager1)
% frf(3) = [m] Anregung y1 (Global Lager1)
% frf(4) = [m] Anregung x2 (Global Lager2)
% frf(5) = [m] Anregung y2 (Global Lager2)
% frf(6) = [m] Antwort x1
% frf(7) = [m] Antwort y1
% frf(8) = [m] Antwort x2
% frf(9) = [m] Antwort y2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Signalvektor zuschneiden auf chirplänge und Averaging im Frequenzbereich
% 
% %Load and extract
% t=   frf(1,:);
% e=   frf(2,:);
% v2=  frf(6,:);
% v1=  v2+e;
% 
% n=1;%AnzahlChirps
 f_max = 200; %[Hz] - Maximale Chirpfrequenz
% 
% l=length(t);
% dl=(l-1)/n;
% 
% for k=1:n;
% 
% a=(k-1)*dl+1;
% b=(k)*dl;
% 
% ct=t(a:b);
% ct=ct-ct(1);
% ce=e(a:b);
% cv1=v1(a:b);
% cv2=v2(a:b);
% 
% % plot(ct,ce)
% 
% NFFT = length(ct);                   % AnzahlMessungen 
% Fs = NFFT/ct(NFFT);                  % Sampling frequency
% vfreq(k,:) = Fs/2*linspace(0,1,NFFT/2+1);
% 
% L=length(ce);
% 
% E(k,:)=fft(ce);
% V1(k,:)=fft(cv1);
% V2(k,:)=fft(cv2);
% % 
% % E(k,:)=fft(xcorr(ce,ce));
% % V1(k,:)=fft(xcorr(cv1,cv1));
% % V2(k,:)=fft(xcorr(cv2,cv2));
% 
% 
% Gs(k,:)=V1(k,:)./E(k,:);
% Gc(k,:)=-V2(k,:)./E(k,:);
% Go(k,:)=-V2(k,:)./V1(k,:);
% 
% 
% 
% end
% 
% %freq=mean(vfreq);
%  
% % mE=mean(E.*conj(E));
% % mGs=mean(Gs.*conj(Gs));
% % mGc=mean(Gc.*conj(Gc));
% % mGo=mean(Go.*conj(Go));
% 
% % mE=mean(E);
% % mGs=mean(Gs);
% % mGc=mean(Gc);
% % mGo=mean(Go);
% 
% freq = vfreq;
% mE=E;
% mGs=Gs;
% mGc=Gc;
% mGo=Go;
% 
% ampE = 2*abs(mE(1:NFFT/2+1));
% 
% ampGs = 2*abs(mGs(1:NFFT/2+1));
% thetaGs=(angle(mGs(1:NFFT/2+1))/pi)*180;
% 
% ampGc = 2*abs(mGc(1:NFFT/2+1));
% thetaGc=(angle(mGc(1:NFFT/2+1))/pi)*180;
% 
% ampGo = 2*abs(mGo(1:NFFT/2+1));
% thetaGo=(angle(mGo(1:NFFT/2+1))/pi)*180;
% 
% % Estimate auto- and cross-PSDs
% Sx1x1 = mean(abs(E).^2,1);
% Sx2x2 = mean(abs(V1).^2,1);
% Sx1x2 = mean(E.*conj(V1),1);
% % Compute coherence estimate
% CV1 = Sx1x2./sqrt(Sx1x1.*Sx2x2);
% CV1 = abs(CV1(1:NFFT/2+1)).^2;
%  
% 
% % Estimate auto- and cross-PSDs
% Sx1x1 = mean(abs(E).^2,1);
% Sx2x2 = mean(abs(V2).^2,1);
% Sx1x2 = mean(E.*conj(V2),1);
% % Compute coherence estimate
% CV2 = Sx1x2./sqrt(Sx1x1.*Sx2x2);
% CV2 = abs(CV2(1:NFFT/2+1)).^2;
%  
% 
% %% Plot magnitude squared coherence
% figure
% subplot(2,1,1)
% plot(freq,CV1) 
% title('Coherence E-V1')
% xlabel('Frequency (Hz)')
% ylabel('Coherence')
% xlim([0,f_max])
% 
% subplot(2,1,2)
% plot(freq,CV2) 
% title('Coherence E-V2')
% xlabel('Frequency (Hz)')
% ylabel('Coherence')
% xlim([0,f_max])




% %
% % 
% figure
% subplot(2,2,1)
% plot(freq,mag2db(ampE)) 
% title('Single-Sided Amplitude Spectrum of E')
% xlabel('Frequency (Hz)')
% ylabel('|y|dB')

%%

figure
subplot(2,3,1)
plot(freq,mag2db(ampGs))
hold on;
plot(Vfreq,mag2db(VampGs))
title('Single-Sided Amplitude Spectrum of Gs: V1/E')
xlabel('Frequency (Hz)')
ylabel('|y|dB')
xlim([0,f_max])
grid on;

subplot(2,3,4)
plot(freq,(thetaGs)) 
hold on;
plot(Vfreq,(VthetaGs)) 
title('Single-Sided Amplitude Spectrum of Gs: V1/E')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,f_max])
grid on;

subplot(2,3,2)
plot(freq,mag2db(ampGc))
hold on;
plot(Vfreq,mag2db(VampGc))
title('Single-Sided Amplitude Spectrum of Gc: -V2/E')
xlabel('Frequency (Hz)')
ylabel('|y| dB')
xlim([0,f_max])
grid on;

subplot(2,3,5)
plot(freq,(thetaGc))
hold on;
plot(Vfreq,(VthetaGc))
title('Single-Sided Amplitude Spectrum of Gc: -V2/E')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,f_max])
grid on;

subplot(2,3,3)
plot(freq,mag2db(ampGo)) 
hold on;
plot(Vfreq,mag2db(VampGo))
title('Single-Sided Amplitude Spectrum of Go: -V2/V1')
xlabel('Frequency (Hz)')
ylabel('|y| dB')
xlim([0,f_max])
grid on;

subplot(2,3,6)
plot(freq,thetaGo) 
hold on;
plot(Vfreq,VthetaGo)
title('Single-Sided Amplitude Spectrum of Go: -V2/V1')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,f_max])
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../Matlab2Tikz');
% help matlab2tikz

Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
[fpathstr,fname,fext] = fileparts(which(mfilename));

cleanfigure;
matlab2tikz('tikzFileComment',['%%% Johannes Maierhofer -', Datum, ' %%%'],'height','\fheight','width','\fwidth','filename',[fname, '__', Datum, '.tikz']);

h = gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf',[fname, '__' ,Datum, '.pdf']); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% 

 save(['FRF_' Datum '.mat'] , 'freq','ampE', 'ampGs','thetaGs','ampGo','thetaGo','ampGc','thetaGc');
 
% figure
% plot(freq,thetaGo) 
% title('Phase of Go: -V2/V1')
% xlabel('Frequency (Hz)')
% ylabel('|y|')
% xlim([0,f_max])