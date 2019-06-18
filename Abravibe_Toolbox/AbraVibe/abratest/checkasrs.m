% CHECKASRS
% Script to test the function ASRS in ABRAVIBE toolbox for MATLAB/Octave

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checkasrs...\n')

close all

if ~exist('fid','var')          % If not set globally, define to print to screen
    fid=1;
end

% Input a sine and check max srs equals Q times the sine at its frequency
fsine=100;      % Test frequency
T=10;            % Test signal length

% Test parameters
N=100;
fs=2000;
Q=[5 10];
fmin=10;
fmax=500;


% Generate sine wave
t=(0:1/fs:T);
x=sin(2*pi*fsine*t);

% Loop through Q values and calculate min, max, and maximax SRS
for q=1:length(Q)
    [Smin(:,q),f]=asrs(x,fs,fmin,fmax,N,Q(q),'min');    
    Smax(:,q)=asrs(x,fs,fmin,fmax,N,Q(q),'max');
    Smm(:,q)=asrs(x,fs,fmin,fmax,N,Q(q),'maximax');
%   Check outputs; Two checks are made:
%   1) That the peak (or valley in the type='min') is approx. Q*amplitude
%   of sine
%   2) That the end value of the SRS approaches max(x) (unity)
    if min(Smin(:,q))/Q(q) < -1.05 | min(Smin(:,q))/Q(q) > -0.95
        fprintf(fid,'Error in max srs value in asrs with type=''min'', Q=%3i\n',Q(q));
    end
    if max(Smax(:,q))/Q(q) > 1.05 | max(Smax(:,q))/Q(q) < 0.95
        fprintf(fid,'Error in max srs value in asrs with type=''max'', Q=%3i\n',Q(q)');
    end
    if max(Smm(:,q))/Q(q) > 1.05 | max(Smm(:,q))/Q(q) < 0.95
        fprintf(fid,'Error in max srs value in asrs with type=''maximax'', Q=%3i\n',Q(q)');
    end
    if abs(1+Smin(end,q)) > 0.1
    	fprintf(fid,'Error in maximax end value in asrs\n')
    end
    if abs(1-Smax(end,q)) > 0.1
    	fprintf(fid,'Error in maximax end value in asrs\n')
    end
    if abs(1-Smm(end,q)) > 0.1
    	fprintf(fid,'Error in maximax end value in asrs\n')
    end
end

fprintf(fid,'Verification completed. If no output was printed the function works as it should\n');