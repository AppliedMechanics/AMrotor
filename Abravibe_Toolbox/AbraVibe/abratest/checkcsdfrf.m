% Test APSDW, ACSDW and XMTRX2FRF by synthesizing data and verify input/outputs

% This script assumes that APSDW is verified already (with apsdtest) 
% Calculating FRF's with ACSDW and APSDW then checks the FRF as well as CSD
% scalings.

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

if ~exist('fid','var')
    fid=1;
end
fprintf(fid,'Starting checkcsdfrf...\n')

close all

% Simulation parameters
N=1024;             % FFT block size
fs=1000;            % Sampling frequency
fid=1;              % Open a file and change fid to write to file

% SISO
x=randn(100*N,1);
y=2*x;
[Gxx,f]=apsdw(x,fs,N);
Gyx=acsdw(x,y,fs,N);
Gyy=apsdw(y,fs,N);
[H,Cm,Cxx]=xmtrx2frf(Gxx,Gyx,Gyy);
if abs(mean(abs(H)) - 2) > 1e-4
    fprintf(fid,'Test of ACSDW and FRFEST:\n')
    fprintf(fid,'Error in FRF scaling! mean(abs(H))=%6.2f, not 2\n',mean(abs(H)))
end
if abs(mean(angle(H))) > 1e-4
    fprintf(fid,'Error in FRF phase! mean(angle(H))=%6.2f, not 0\n',mean(angle(H)))
end
if abs(mean(Cm) - 1) > 1e-4
    fprintf(fid,'Error in Coherence! mean(Cm)=%6.2f, not 1\n',mean(Cm))
    figure
    plot(f,Cm)
end

% SIMO
% Tests to be added for SIMO, MISO, MIMO

% Done.
fprintf('Verification completed. If no outputs where printed, the ACSDW and XMTRX2FRF commands work as they should\n')