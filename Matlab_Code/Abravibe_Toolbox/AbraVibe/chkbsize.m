function chkbsize(x,fs,N);
% CHKBSIZE  Compare up to three blocksizes for PSD calculation (Welch's method)
%
%       chkbsize(x,fs,N)
%
%       x       Data in column vector
%       fs      Sampling frequency in Hz
%       N       Vector with up to three blocksizes to be tried
%
% Example:
% chkbsize(x,fs,32*1024*[1 2 4])
% Compares block sizes of 32, 64, and 128 kSamples.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

L=length(N);
if L == 1
    error('You must specify at least two blocksizes. Otherwise use APSDW')
end

% Calculate PSD with each blocksize and put in cell array Pxx
for n=1:length(N)
    [Pxx{n},f{n}] = apsdw(x,fs,N(n));
end

% Plot PSDs overlaid
figure
if L == 2
    semilogy(f{1},Pxx{1},f{2},Pxx{2})
    xlabel('Frequency [Hz]')
    legend(int2str(N(1)),int2str(N(2)))
elseif L == 3
    semilogy(f{1},Pxx{1},f{2},Pxx{2},f{3},Pxx{3})
    xlabel('Frequency [Hz]')
    legend(int2str(N(1)),int2str(N(2)),int2str(N(3)))
end