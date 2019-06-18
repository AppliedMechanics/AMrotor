% CHECKMCK2FRF
%
% This script checks the output of MCK2FRF for flexibility, mobility, and
% accelerance type, using an SDOF system.

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checkmck2frf...\n');

% Define the SDOF system; This system has fr=1000/2/pi=159.2 Hz, and
% relative damping of 5%
m=1;
c=100;
k=1e6;

f=(0:1/pi:1000)';

% Calculate the three FRFs
Hd=mck2frf(f,m,c,k,1,1,'d');
Hv=mck2frf(f,m,c,k,1,1,'v');
Ha=mck2frf(f,m,c,k,1,1,'a');

% Checks:
% 1) Check that d,v,a are exactly imaginary/real/imaginary at fr=159 Hz
% 2) Check that Hd(1)=1/k
% 3) Check that Ha(end)=1/m

idx=find(f==1000/2/pi);

% Check phases
if ~isreal(j*Hd(idx))
    fprintf(fid,'Error in mck2frf, phase of flexibility not -pi/2!\n')
end
if ~isreal(Hv(idx))
    fprintf(fid,'Error in mck2frf, phase of flexibility not -pi/2!\n')
end
if ~isreal(j*Ha(idx)) 
    fprintf(fid,'Error in mck2frf, phase of flexibility not -pi/2!\n')
end

% Check DC value of Hd
if Hd(1) ~= 1/k
    fprintf(fid,'Error in mck2frf, type d: DC value not 1/k!\n')
end

% Check end assymptote of Ha
if Ha(end)*m > 1.05
    fprintf(fid,'Error in mck2frf, type a: does not approach 1/m!\n')
end

% Done.
fprintf(fid,'Verification completed. If no outputs were printed, the MCK2FRF command works as it should (for SDOF)\n');
