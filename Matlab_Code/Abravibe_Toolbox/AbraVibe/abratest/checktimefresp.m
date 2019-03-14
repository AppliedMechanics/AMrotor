% CHECKTIMEFRESP
% Script to test the function TIMEFRESP in ABRAVIBE toolbox for MATLAB/Octave

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

if ~exist('fid','var')
    fid=1;
end
fprintf(fid,'Starting checktimefresp...\n')

% FFT parameters
fs=1200;
N=4096;
NoAvgs=100;
f=[0:fs/N:fs/2]';

% Set up 3DOF system
% M=eye(3);
M=[1 0 0;0 2 0;0 0 1];
K=1e6*[2 -1 0;-1 2 -2;0 -2 3];
C=3e-4*K;

% Solve for modes
[p,V]=mck2modal(M,C,K);
[fr,zr]=poles2fz(p);

Htrue=mck2frf(f,M,C,K,1:3,1:3,'d');

% Create burst random input forces
x=randn(NoAvgs*N,3);
xn=zeros(NoAvgs*N,3);
for n=1:NoAvgs
    xn((n-1)*N+1:(n-1)*N+N/2,:)=x((n-1)*N/2+1:n*N/2,:);
end
x=xn;
clear xn

OutType='d';
indof=[1:3];
outdof=[1:3];

%========================================================================
% Check timefresp called with p, V
y=timefresp(x,fs,p,V,indof,outdof,OutType);
% Make MIMO analysis of all measurement data in x and y, no overlap!
[Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,N,1);
[H,Cm,Cxx]=xmtrx2frf(Pxx,Pyx,Pyy);
% Truncate to 400 Hz
idx=find(f <= 400);
Htrue=Htrue(idx,:,:);
H=H(idx,:,:);
f=f(idx);
% Check that estimated FRFs are within tolerance
for n=1:3
    if norm(Htrue(:,:,n)-H(:,:,n)) > 1e-3
        fprintf(fid,'ERROR in CHECKTIMEFRESP for p, V input, and for reference %i\n',n)
    end
end

%========================================================================
% Check timefresp called with M,C,K
y=timefresp(x,fs,M,C,K,indof,outdof,OutType);
% Make MIMO analysis of all measurement data in x and y
[Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,N,1);
[H,Cm,Cxx]=xmtrx2frf(Pxx,Pyx,Pyy);
% Truncate to 400 Hz
idx=find(f <= 400);
Htrue=Htrue(idx,:,:);
H=H(idx,:,:);
f=f(idx);
% Check that estimated FRFs are within tolerance
for n=1:3
    if norm(Htrue(:,:,n)-H(:,:,n)) > 1e-3
        norm(Htrue(:,:,n)-H(:,:,n))
        fprintf(fid,'ERROR in CHECKTIMEFRESP for M,C,K input and for reference %i\n',n)
    end
end

%========================================================================
% Check timefresp called with M,z,K
y=timefresp(x,fs,M,zr,K,indof,outdof,OutType);
% Make MIMO analysis of all measurement data in x and y
[Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,N,1);
[H,Cm,Cxx]=xmtrx2frf(Pxx,Pyx,Pyy);
% Truncate to 400 Hz
idx=find(f <= 400);
Htrue=Htrue(idx,:,:);
H=H(idx,:,:);
f=f(idx);
% Check that estimated FRFs are within tolerance
for n=1:3
    if norm(Htrue(:,:,n)-H(:,:,n)) > 1e-3
        fprintf(fid,'ERROR in CHECKTIMEFRESP for M,z,K input and for reference %i\n',n)
    end
end

%========================================================================
% Check timefresp called with M,C,K and with acceleration output; if this
% works all the others should work with v, and a output
OutType='a';
z=.02*[1 1 1]';
Htrue=mkz2frf(f,M,K,z,1:3,1:3,OutType);
y=timefresp(x,fs,M,z,K,indof,outdof,OutType);
L=length(y(:,1));
x=x(1:L,:);
% Make MIMO analysis of all measurement data in x and y
[Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,N,1);
[H,Cm,Cxx]=xmtrx2frf(Pxx,Pyx,Pyy);
% Truncate to 50 to 400 Hz
idx=find(f > 50 & f <= 400);
Htrue=Htrue(idx,:,:);
H=H(idx,:,:);
f=f(idx);
% Check that estimated FRFs are within tolerance
for n=1:3
    if norm((Htrue(:,:,n)-H(:,:,n))./Htrue(:,:,n)) > 3
        fprintf(fid,'ERROR in CHECKTIMEFRESP for M,C,K input and for reference %i, for acceleration output\n',n)
    end
end


% Done.
fprintf(fid,'Verification completed. If no outputs were printed, TIMEFRESP works ok.\n')

