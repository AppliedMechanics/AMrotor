function [Pxx, f, Nw] = apsdsp(varargin);
% APSDSP  Power Spectral Density, PSD, by smoothed periodogram
%
%           [Pxx,f,Nw] = apsdsp(x,fs,N,winstr) produces a linear
%                        resolution PSD, similar to APSDW
%           [Pxx,f,Nw] = apsdsp(x,fs,fmin,fmax,Nfreqs,Lsmin,winstr) produces a logartihmic
%                        frequency resolution PSD
%
%            Pxx        PSD in units of x squared per Hz (EU^2/Hz)
%            f          Frequency axis in Hz
%            Nw         Length of smoothing window. Determines random
%                       error; eps_r=1/sqrt(Nw). For logarithmic frequency
%                       resolution, Nw is a vector with length(f) with the smoothing
%                       window length for each frequency bin in Pxx.
%
%            x          Time data in column
%            fs         Sampling frequency in Hz
%            N          'Blocksize', as for Welch (see apsdw)
%            winstr     String with window function, e.g. 'boxcar' (default)
%            fmin       First frequency value
%            fmax       Last frequency value
%            Nfreqs     Number of spectrum values to calculate between fmin and fmax
%            Lsmin      Minimum smoothing window length (for first freq.)
%
% The PSD is computed by the smoothed periodogram method.
% Note that the window used by this method is quite different from the time
% window (e.g. Hanning window) used by Welch's method for PSD computation.
% The window should normally be 'boxcar', which means it does not need to
% be specified.
% A logarithmic = 'log' produces a
% frequency resolution with constant relative bandwidth. The first
% frequency value will be given by length(win), and higher frequencies
% will have a resolution in a logarithmic fashion.
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Parse input parameters and find out which call is made
x=varargin{1};
fs=varargin{2};
if nargin <= 4
    Nin=varargin{3};
    if nargin == 4
        winstr=varargin{4};
    end
else
    fmin=varargin{3};
    fmax=varargin{4};
    Nfreqs=varargin{5};
    Lsmin=varargin{6};
    if nargin == 7
        winstr=varargin{7};
    end
end

% Input checks
if nargin == 3          % Call is for linear resolution
    winstr='boxcar';
    res='LIN';
elseif nargin == 4
    res='LIN';          % Call is for linear resolution
elseif nargin == 6
    winstr='boxcar';    % Call is for logarithmic resolution
    res='LOG';
elseif nargin == 7
    res='LOG';
end

[NSamp,NVect]=size(x);
% Loop through channels if more than one column
for chan = 1:NVect
    % First remove mean
    y=x(:,chan);            
    y=y-mean(y);
    
    % Compute 'periodogram' (we divide by L^2, not L, see df line below)
    L=length(y);
    if mod(L,2) ~= 0
        y=y(1:end-1);               % Ensure even length of y
        L=L-1;
    end
    p=1/L^2*abs(fft(y)).^2;
    p=2*p(1:L/2+1);                 % Single-sided
    df=fs/L;
    p=p/df;                         % Could also have been computed as dt*1/L*abs(fft(x))
    p(1)=0;
    Lp=length(p);
    fp=(0:df:(Lp-1)*df)';
    
    if strcmp(res,'LIN')
        % Change blocksize to actual number of freq. lines
        N=Nin/2+1;
        % Determine smoothing window length
        Nw=floor(2*(Lp-2)/(N+1)+1);
        if mod(Nw,2) == 0
            Nw=Nw-1;                % Ensure odd length
        end
        win=feval(winstr,Nw);
        % Ensure that the sum of the window is unity
        win = win/sum(win);
        % Smooth estimate by window
        Nstep=(Nw-1)/2;          % 50 % overlap
        P=zeros(N,1);
        f=zeros(N,1);
        for n =1:N
            P(n)=sum(p((n-1)*Nstep+2:(n+1)*Nstep+2).*win);
            f(n)=(n*(Nw-1)/2+2)*df;
        end
    elseif strcmp(res,'LOG')
        % Calculate step parameter s
        s=log(fmax/fmin)/(Nfreqs-1);
        %     Lsmin=floor(2*fmin/df);
        P=zeros(Nfreqs,1);
        f=zeros(Nfreqs,1);
        Nw=zeros(Nfreqs,1);
        % Loop through frequencies
        for n = 1:Nfreqs
            % Determine frequency to calculate
            ft=fmin*exp(s*(n-1));
            % find closest actual frequency
            [dum,k]=min(abs(fp-ft));
            f(n)=fp(k);
            % Determine nominal smoothing window length
            Nwt=round(min(Lsmin*exp(s*(n-1)),2*(fs/2-f(n))/df));
            if mod(Nwt,2) == 0
                Nwt=Nwt+1;
            end
            Nw(n)=Nwt;
            win=feval(winstr,Nw(n));
            win = win/sum(win);
            if k+(Nw(n)-1)/2 < Lp
                pt=p(k-(Nw(n)-1)/2:k+(Nw(n)-1)/2);
                P(n)=sum(pt.*win);
            end
        end
        % Check if there are values at higher freqs that did not get filled in
        % due to the width of the smoothing window being too high
        idx=min(find(f(2:end) == 0));
        if ~isempty(idx)
            f=f(1:idx-1);
            P=P(1:idx-1);
            Nw=Nw(1:idx-1);
        end
    end
    if chan == 1
        Pxx=P;
    else
        Pxx(:,chan)=P;
    end
end