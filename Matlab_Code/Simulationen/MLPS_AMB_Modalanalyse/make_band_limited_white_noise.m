% make band limited white noise
fsample = 1e3;
fmax = 250;
t = 0:1/fsample:10;
[B,A] = fir1(48,fmax/(fsample/2),'low');
fvtool(B,A,'Fs',fsample)

white_noise = randn(size(t));
x = filter(B, A, white_noise);

save noise250Hz t x