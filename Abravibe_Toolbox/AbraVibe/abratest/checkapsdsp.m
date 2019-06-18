% Verify apsdw output is correct

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

if ~exist('fid','var')
    fid=1;
end
fprintf(fid,'Starting checkapsd...\n')


% Define parameters for FFT analysis
fs=1000;
N=4096;
M=100;              % Number independent averages for Welch
Nfft=2*M-1;         % Total number of blocks to be calculated

% Create random time data
x=randn(N*M,1);

% Compute PSD using apsd
[P,f,Nblocks]=apsdw(x,fs,N);

% Verify output
% Test 1: Check that RMS of time data equals rms computed from PSD. This
% also assures that f is correctly defined
df=f(2);
Rtime=std(x);
Rpsd=sqrt(df*sum(P));
if abs((Rtime-Rpsd)/Rtime) > .001
    fprintf(fid,'RMS value mismatch! Rtime=%6.2f, Rpsd=%6.2f\n',Rtime,Rpsd)
end

% Test 2: Check that lengts of f and P are both N/2+1
if length(f) ~= N/2+1 | length(f) ~= length(P)
    fprintf(fid,'Wrong data lengths! length(f)=%i, length(P)=%i, N/2+1=%i\n',length(f),length(P),N/2+1);
end

% Test 3: Check that Nblocks is 2*M-1
if Nblocks ~= 2*M-1
    fprintf(fid,'Wrong number of blocks reported in Nblocks: %i\n',Nblocks);
end

% Test 4: Check frequency axis end value correct
if f(end) ~= fs/2
    fprintf(fid,'Wrong frequency end value: f(end)=%6.2f\n',f(end))
end

% Now check that APSDW can handle several columns
x=[x 2*x];
P=apsdw(x,fs,N);
if 4*sum(P(:,1)) ~= sum(P(:,2))
    fprintf(fid,'Something wrong with more than one column in x!\n')
end

% Done.
fprintf(fid,'Verification completed. If no outputs where printed, the APSDW command works as it should\n')
