% generate_white_noise
t=0:1e-3:1;
fs=1/(t(2)-t(1));
fn = 0.5*fs;
fd = 1;
fu = 200;
[B1,A1] = fir1(48,[fd fu]/fn);
fvtool(B1,A1,'Fs',fs)
noise_limited = filter(B1,A1,randn(10000,1));
t=0:1/fs:(length(noise_limited)-1)/fs;
[f,Y] = perform_fft(t,noise_limited);
figure
semilogy(f,Y)