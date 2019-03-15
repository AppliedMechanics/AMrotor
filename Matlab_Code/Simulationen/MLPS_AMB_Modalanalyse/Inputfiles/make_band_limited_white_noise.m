% make band limited white noise
% fsample = 1e4;
% fmax = 250;
% t = 0:1/fsample:1;
% [B,A] = fir1(48,fmax/(fsample/2),'low');
% fvtool(B,A,'Fs',fsample)
% 
% white_noise = randn(size(t));
% x = filter(B, A, white_noise);

clear
close all

fsample = 1e3;
fmax = 250;
t = 0:1/fsample:10;
d = fdesign.lowpass('Fp,Fst,Ap,Ast',fmax,fmax*1.2,0.5,40,fsample);
B = design(d);
% create white Gaussian noise the length of your signal
noise = randn(size(t));
% create the band-limited Gaussian noise
x = filter(B,noise);


save noise250Hz_1kHz t x

% figure
% [f,Y]=perform_fft(t,y);
% subplot(2,1,1),plot(t,y),title('10kHz'),xlabel('t'),ylabel('y')
% subplot(2,1,2),semilogy(f,Y),xlabel('f/Hz'),ylabel('FFT Y'),xlim([0 1000])
% 
% figure
% t_1kHz = t(1):1.1e-3:t(end);
% % for k=1:length(t_1kHz)
% %     tcurr = t_1kHz(k);
% %     y_1kHz(k)=interp1(t,y,tcurr,'linear');
% % end
% y_1kHz=interp1(t,y,t_1kHz,'linear');
% [f_1kHz,Y_1kHz]=perform_fft(t_1kHz,y_1kHz);
% subplot(2,1,1),plot(t_1kHz,y_1kHz),title('1kHz linear'),xlabel('t'),ylabel('y')
% subplot(2,1,2),semilogy(f_1kHz,Y_1kHz),xlabel('f/Hz'),ylabel('FFT Y'),xlim([0 1000])
% 
% 
%%
fsample = 1e3;
fmax = 250;
t = 0:1/fsample:1;
d = fdesign.lowpass('Fp,Fst,Ap,Ast',fmax,fmax*1.2,0.5,40,fsample);
B = design(d);
% create white Gaussian noise the length of your signal
x = randn(size(t));
% create the band-limited Gaussian noise
y = filter(B,x);


% save Inputfiles/noise250Hz_10kHz t x

figure
[f,Y]=perform_fft(t,y);
subplot(2,1,1),plot(t,y),title('1kHz'),xlabel('t'),ylabel('y')
subplot(2,1,2),semilogy(f,Y),xlabel('f/Hz'),ylabel('FFT Y'),xlim([0 1000])


figure
t_10kHz = t(1):1e-4:t(end);
y_10kHz=interp1(t,y,t_10kHz,'linear');
[f_10kHz,Y_10kHz]=perform_fft(t_10kHz,y_10kHz);
subplot(2,1,1),plot(t_10kHz,y_10kHz),title('10kHz linear'),xlabel('t'),ylabel('y')
subplot(2,1,2),semilogy(f_10kHz,Y_10kHz),xlabel('f/Hz'),ylabel('FFT Y')%,xlim([0 1000])
% 
% figure
% t_100kHz = t(1):1.1e-5:t(end);
% y_100kHz=interp1(t,y,t_100kHz,'linear');
% [f_100kHz,Y_100kHz]=perform_fft(t_100kHz,y_100kHz);
% subplot(2,1,1),plot(t_100kHz,y_100kHz),title('100kHz linear'),xlabel('t'),ylabel('y')
% subplot(2,1,2),semilogy(f_100kHz,Y_100kHz),xlabel('f/Hz'),ylabel('FFT Y')%,xlim([0 1000])