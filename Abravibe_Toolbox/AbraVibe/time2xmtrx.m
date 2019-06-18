function [Pxx,Pyx,Pyy,f,NBlocks] = time2xmtrx(x,y,fs,N,POverlap)
%TIME2XMTRX Calculate In-/Out cross spectral matrices for MIMO analysis
%
%           [Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,N,POverlap), OR
%           [Pxx,Pyx,Pyy,f,Nblocks] = time2xmtrx(x,y,fs,w,POverlap), OR
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
%           N           FFT block size, power of 2 (1024, 2048,...)
%           w           time window, e.g. ahann(1024)
%           POverlap    Percent overlap, >= 0, (default = 50)
%
%           D           Number of time records (columns in y)
%
% TIME2XMTRX by default uses 50% overlap and Hanning window to produce the 
% auto and cross spectral densities needed for multiple-input/multiple-output 
% analysis such as FRF estimates, principal components etc.
% Time data in x and y MUST BE in columns.
%
% See also WELCHERR APSDW ACSDW XMTRX2FRF

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2013-02-07 Changed default overlap to 50% in accordance with
%                         help text. Also introduced truncation if lengths
%                         of x, y not same, to avoid weird results
% This file is part of ABRAVIBE Toolbox for NVA

% Set up depending on input parameters
if nargin < 4
   error('Wrong number of input variables, must be 4 or 5!');
elseif nargin == 4
    POverlap=50;
end

if length(x(:,1)) ~= length(y(:,1))
    L=min(length(x(:,1)),length(y(:,1)));
    x=x(1:L,:);
    y=y(1:L,:);
end

[Pxx,f,NBlocks]=acsdw(x,x,fs,N,POverlap);
for n=1:length(x(1,:))
    Pxx(:,n,n)=real(Pxx(:,n,n));
end
Pyx=acsdw(x,y,fs,N,POverlap);
Pyy=apsdw(y,fs,N,POverlap);

