function [Pxx,Pyx,Pyy,f,NBlocks] = time2xmtrxc(x,y,fs,N,NCycles)
% TIME2XMTRXC   Computes In-/Out cross spectral matrices from time data by cyclic averaging
%
%           [Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrxc(x,y,fs,N,NCycles), OR
%           [Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrxc(x,y,fs,w,w_cyc), OR
%
%           Pxx         Input cross spectral matrix, N/2+1-by-R-by-R
%           Pyx         In-/Out cross spectral matrix, N/2+1-by-D-by-R
%           Pyy         PSD of time signal(s) y, N/2+1-by-D
%           f           Frequency vector for Pyy, N/2+1-by-D
%           NBlocks     Number of overlapped FFT blocks used (see WELCHERR)
%
%           x           Input time data in column vector(s). If more than one
%                       column, each column is treated separately
%           y           Output time data in column vector(s). If more than one
%                       column, each column is treated separately
%           fs          Sampling frequency for y
%           N           FFT block size, using rectangular window, power of 2 (1024, 2048,...)
%           w           time window, usually boxcar(N) for cyclic averaging
%           NCycles     Number of cycles to average, 0 for all data (only
%                       one time block is sent to PSD computation)
%                       If NCycles is a vector, e.g. ahann(4*N), it is treated as a window
%                       function to be put on each larger block before the
%                       cyclic averaging.
%           w_cyc       Cyclic window, usually ahann(Nc*N) for cyclic averaging
%
%           D           Number of time records (columns in y)
%
% Time data in x and y MUST BE in columns.
%
% See also WELCHERR APSDW ACSDW XMTRX2FRF

% Copyright (c) 2009 by Anders Brandt
% Email: abra@ib.sdu.dk
% Version: 0.1 2009-05-25
% This file is part of ABRAVIBE Toolbox for NVA

% Reference:
% Phillips, A. W. & Allemang, R. J. An overview of MIMO-FRF excitation
% /averaging/processing techniques Journal of Sound and Vibration, 2003, 
% 262, pp. 651-675.

% Set up depending on input parameters
if nargin ~= 5
   error('Wrong number of input variables, must be 5!');
end

if length(N) > 1
    w=N;
    N=length(w);
else
    w=boxcar(N);
end

if NCycles == 0
    NCycles=floor(length(x)/N);
    AllCycles=1;                % For check at end of this file
    CyclicWindow=boxcar(N);
elseif length(NCycles) > 1
    AllCycles=0;
    CyclicWindow=NCycles;
    NCycles=floor(length(NCycles)/N);
else
    AllCycles=0;
    CyclicWindow=boxcar(N);
end

% Make the cyclic averaging in time domain
startidx=1;             % Index into start of block in cyclic average output
xnew=[]; ynew=[];
xidx=0;
CompFactor=winacf(CyclicWindow)/sqrt(winenbw(CyclicWindow));
while xidx(end) + N*NCycles <= length(x)
    xnew=[xnew;zeros(N,1)];
    ynew=[ynew;zeros(N,1)];
    if startidx == 1
        xidx=1:N*NCycles;
    else
        xidx=xidx+N*NCycles;
    end
    x(xidx)=x(xidx).*CyclicWindow*CompFactor;
    y(xidx)=y(xidx).*CyclicWindow*CompFactor;
    for n = 1:NCycles
        xnew(startidx:startidx+N-1) = xnew(startidx:startidx+N-1)+x(xidx((n-1)*N+1):xidx(n*N));
        ynew(startidx:startidx+N-1) = ynew(startidx:startidx+N-1)+y(xidx((n-1)*N+1):xidx(n*N));
    end
    startidx=startidx+N;
end
xnew=xnew/NCycles;
ynew=ynew/NCycles;

[Pxx,f,NBlocks]=acsdw(xnew,xnew,fs,w,0);
Pyx=acsdw(xnew,ynew,fs,w,0);
Pyy=apsdw(ynew,fs,w,0);

% If all data were used for cyclic averages, report number of blocks in
% NBlocks
if AllCycles == 1
    NBlocks=NCycles;
end