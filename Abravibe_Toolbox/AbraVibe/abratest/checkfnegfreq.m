% Test fnegfreq
%
% The test is done on an fft result of Gaussian noise, so it contains much
% frequency information. fnegfreq is used to recreate thrown-away values,
% which are compared to the original values.

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checkfnegfreq...\n')

close all

N=1024;                     % Blocksize


% Produce random noise
y=randn(N,1);

% Make an FFT
Y=fft(y);

% Throw away last N/2-1 points (keep all up to fs/2), in reduced vector
Yr=Y(1:N/2+1);

% Now recreate those thrown-away values using fnegfreq in extended vector
Ye=fnegfreq(Yr,'fft');
if norm(Y-Ye) > 1e-12
    fprintf(fid,'Error in FNEGFREQ with ''FFT'' parameter. Reproduced values not correct!\n')
end

% Done.
fprintf('Verification completed. If no outputs where printed, the FNEGFREQ command works as it should\n')
