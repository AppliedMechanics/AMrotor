% LINSPECCHECK
% This script checks the function ALINSPEC by checking it agains APSD

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checklinspec...\n')

close all

% Simulation parameters
fs=10000;
N=8192;
K=100;          % Number of independent blocks of data
df=fs/N;

x=randn(K*N,1);
[Pxx,f]=apsdw(x,fs,N);
Lxx=alinspec(x,fs,ahann(N),2*K-1,50);   % Should be same as used for psd

Pxxl=Lxx.^2/winenbw(ahann(512))/df;

if round(10000*min(Pxx./Pxxl)) ~= round(10000*max(Pxx./Pxxl))
    fprintf(fid,'CHECKLINSPEC error:\n')
    fprintf(fid,'ALINSPEC does not correspond with APSDW output!\n')
    figure
    semilogy(f,Pxx,f,Pxxl)
    legend('APSDW','From LINSPEC')
end


% Done.
fprintf(fid,'Verification completed. If no outputs where printed, the ALINSPEC command works as it should\n')