%% Beispiel aus Brandt S.390 -> Random Signal with known spectral density
f = 0:1:500;
Gxx = [ones(1,251),zeros(1,250)];
fs = 2*max(f);
df = f(2)
% Compute the RMS level
R=sqrt(df*sum(Gxx))
% We need a new freq axis length
L=100*1024;
newx=linspace(f(1),f(end),ceil(L/2)+1);
%Interpolate Gxx onto the new x-axis
P = interp1(f,Gxx,newx,'linear','extrap');
P=P(:);
%Next we will compute the amplitudes of the spectrum as the square root of the PSD. We then add a random phase betweenn ? ? and ? , and produce the negative frequencies with the Fourier transform symmetry properties (even amplitude, and odd phase, in this case). Then we compute the IFFT, and scale the RMS to our variable R above. This final part is done by the following code. Note that the command rand creates uniformly distributed values between zero and unity, so we make a trick to get values between –0.5 and 0.5.
A=sqrt(P);
phi=2*pi*(rand(ceil(L/2)+1,1)-0.5);
%Create negative freq in upper half of the block(as FFT/IFFT wants it)
A=[A(1); 0.5*A(2:end); 0.5*A(end-1:-1:2)];
phi = [phi;-phi(end-1:-1:2)];
phi(end)=0; % phi of fs/2 must be real
y=sqrt(2*fs*length(A))*real(ifft((A.*exp(j*phi))));
y=y-mean(y);
%scale y to proper RMS level;
y=R/std(y)*y;

%% plotte die PSD
[Pxx,fxx,Nblocks]=acsdw(y,y,fs,hanning(1024),50);
plot(fxx,Pxx)
title('PSD')
xlabel('f/Hz')

%% plotte FFT
tFFT=0:1/fs:1/fs*length(y);
[fFFT,YFFT] = perform_fft(tFFT,y);
figure
plot(fFFT,YFFT)
title('FFT')
xlabel('f/Hz')