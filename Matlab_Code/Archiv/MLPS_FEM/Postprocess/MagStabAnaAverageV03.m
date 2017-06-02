%% Signalvektor zuschneiden auf chirplänge und Averaging im Frequenzbereich

% %Load and extract
% t=   t(1:((end+1)/2));
% e=   e(1:((end+1)/2));
% v1=  v1(1:((end+1)/2));
% v2=  v2(1:((end+1)/2));



n=20;%AnzahlChirps

l=length(t);
dl=(l-1)/n;

for k=1:n;

a=(k-1)*dl+1;
b=(k)*dl;

ct=t(a:b);
ct=ct-ct(1);
ce=e(a:b);
cv1=v1(a:b);
cv2=v2(a:b);

% plot(ct,ce)

NFFT = length(ct);                   % AnzahlMessungen 
Fs = NFFT/ct(NFFT);                  % Sampling frequency
vfreq(k,:) = Fs/2*linspace(0,1,NFFT/2+1);

L=length(ce);

E(k,:)=fft(ce);
V1(k,:)=fft(cv1);
V2(k,:)=fft(cv2);
% 
% E(k,:)=fft(xcorr(ce,ce));
% V1(k,:)=fft(xcorr(cv1,cv1));
% V2(k,:)=fft(xcorr(cv2,cv2));


Gs(k,:)=V1(k,:)./E(k,:);
Gc(k,:)=-V2(k,:)./E(k,:);
Go(k,:)=-V2(k,:)./V1(k,:);



end

Vfreq=mean(vfreq);
 
% mE=mean(E.*conj(E));
% mGs=mean(Gs.*conj(Gs));
% mGc=mean(Gc.*conj(Gc));
% mGo=mean(Go.*conj(Go));

mE=mean(E);
mGs=mean(Gs);
mGc=mean(Gc);
mGo=mean(Go);


VampE = 2*abs(mE(1:NFFT/2+1));

VampGs = 2*abs(mGs(1:NFFT/2+1));
VthetaGs=(angle(mGs(1:NFFT/2+1))/pi)*180;


VampGc = 2*abs(mGc(1:NFFT/2+1));
VthetaGc=(angle(mGc(1:NFFT/2+1))/pi)*180;

VampGo = 2*abs(mGo(1:NFFT/2+1));
VthetaGo=(angle(mGo(1:NFFT/2+1))/pi)*180;

% Estimate auto- and cross-PSDs
Sx1x1 = mean(abs(E).^2,1);
Sx2x2 = mean(abs(V1).^2,1);
Sx1x2 = mean(E.*conj(V1),1);
% Compute coherence estimate
CV1 = Sx1x2./sqrt(Sx1x1.*Sx2x2);
CV1 = abs(CV1(1:NFFT/2+1)).^2;
 

% Estimate auto- and cross-PSDs
Sx1x1 = mean(abs(E).^2,1);
Sx2x2 = mean(abs(V2).^2,1);
Sx1x2 = mean(E.*conj(V2),1);
% Compute coherence estimate
CV2 = Sx1x2./sqrt(Sx1x1.*Sx2x2);
CV2 = abs(CV2(1:NFFT/2+1)).^2;
 

% Plot magnitude squared coherence
figure
subplot(2,1,1)
plot(Vfreq,CV1) 
title('Coherence E-V1')
xlabel('Frequency (Hz)')
ylabel('Coherence')
xlim([0,200])

subplot(2,1,2)
plot(Vfreq,CV2) 
title('Coherence E-V2')
xlabel('Frequency (Hz)')
ylabel('Coherence')
xlim([0,200])




% %
% % 
% figure
% subplot(2,2,1)
% plot(freq,mag2db(ampE)) 
% title('Single-Sided Amplitude Spectrum of E')
% xlabel('Frequency (Hz)')
% ylabel('|y|dB')


figure
subplot(2,3,1)
plot(Vfreq,mag2db(VampGs)) 
title('Single-Sided Amplitude Spectrum of Gs: V1/E')
xlabel('Frequency (Hz)')
ylabel('|y|dB')
xlim([0,200])

subplot(2,3,4)
plot(Vfreq,(VthetaGs)) 
title('Single-Sided Amplitude Spectrum of Gs: V1/E')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,200])

subplot(2,3,2)
plot(Vfreq,mag2db(VampGc)) 
title('Single-Sided Amplitude Spectrum of Gc: -V2/E')
xlabel('Frequency (Hz)')
ylabel('|y| dB')
xlim([0,200])

subplot(2,3,5)
plot(Vfreq,(VthetaGc)) 
title('Single-Sided Amplitude Spectrum of Gc: -V2/E')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,200])

subplot(2,3,3)
plot(Vfreq,mag2db(VampGo)) 
title('Single-Sided Amplitude Spectrum of Go: -V2/V1')
xlabel('Frequency (Hz)')
ylabel('|y| dB')
xlim([0,200])

subplot(2,3,6)
plot(Vfreq,VthetaGo) 
title('Single-Sided Amplitude Spectrum of Go: -V2/V1')
xlabel('Frequency (Hz)')
ylabel('Phase')
xlim([0,200])

% 
Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
 save(['FRF_Versuch_' Datum '.mat'] , 'Vfreq','VampE', 'VampGs','VthetaGs','VampGo','VthetaGo','VampGc','VthetaGc');

% figure
% plot(freq,thetaGo) 
% title('Phase of Go: -V2/V1')
% xlabel('Frequency (Hz)')
% ylabel('|y|')
% xlim([0,200])