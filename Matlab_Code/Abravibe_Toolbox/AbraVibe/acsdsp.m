function [Pyx, f, Nw] = acsdsp(varargin);
% ACSDSP  Cross-Spectral Density, CSD, by smoothed periodogram method
%
%           [Pyx,f,Nw] = acsdsp(x,y,fs,N,winstr)
%                        produces a linear resolution CSD, similar to ACSDW
%           [Pyx,f,Nw] = acsdsp(x,y,fs,fmin,fmax,Nfreqs,Lsmin,winstr)
%                        produces a logartihmic frequency resolution CSD
%
%            Pyx        CSD in units of x squared per Hz (EU^2/Hz)
%            f          Frequency axis in Hz
%            Nw         Length of smoothing window. Determines random
%                       error; eps_r=1/sqrt(Nw). For logarithmic frequency
%                       resolution, Nw is a vector with length(f).
%
%            x          Input time data in column(s)
%            y          Output time data in column(s)
%            fs         Sampling frequency in Hz
%            N          'Blocksize', as for Welch (see apsdw)
%            winstr     String with window function, e.g. 'boxcar' (default)
%            fmin       First frequency value
%            fmax       Last frequency value
%            Nfreqs     Number of spectrum values to calculate between fmin and fmax
%            Lsmin      Minimum smoothing window length (for first freq.)
%
% The CSD is computed by the smoothed periodogram method.
% Note that the window used by this method is quite different from the time
% window (e.g. Hanning window) used by Welch's method for CSD computation.
% The window should normally be 'boxcar', which means it does not need to
% be specified.
% A logarithmic frequency axis uses frequency resolution with constant
% relative bandwidth. The first frequency value will be given by
% fs/length(win), and higher frequencies will have a resolution in a
% logarithmic fashion.
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23  
%          1.1 2012-07-08 Fixed bugs for multichannel data
% This file is part of ABRAVIBE Toolbox for NVA

% Parse input parameters and find out which call is made
x=varargin{1};
y=varargin{2};
fs=varargin{3};
if nargin <= 5
    N=varargin{4};
    if nargin == 5
        winstr=varargin{5};
    end
else
    fmin=varargin{4};
    fmax=varargin{5};
    Nfreqs=varargin{6};
    Lsmin=varargin{7};
    if nargin == 8
        winstr=varargin{8};
    end
end

% Input checks
if nargin == 4          % Call is for linear resolution
    winstr='boxcar';
    res='LIN';
elseif nargin == 5
    res='LIN';          % Call is for linear resolution
elseif nargin == 7
    winstr='boxcar';    % Call is for logarithmic resolution
    res='LOG';
elseif nargin == 8
    res='LOG';
end

% First remove mean
[nx,mx]=size(x);
[ny,my]=size(y);
if nx ~= ny
    minL=min(nx,ny);
    x=x(1:minL,:);
    y=y(1:minL,:);
    nx=minL;
    ny=minL;
end
L=length(x(:,1));                   
% Remove mean from all columns
x=x-ones(nx,1)*mean(x);             
y=y-ones(ny,1)*mean(y);          

% Change blocksize to actual number of freq. lines (only used for linear
% resolution)
N=N/2+1;


% Loop through all combinations of input and output
xin=x;
yin=y;
for r = 1:mx
    x=xin(:,r);
    for d = 1:my
        y=yin(:,d);
        % Compute 'periodogram'
        p=1/L^2*conj(fft(x)).*fft(y);
        p=2*p(1:L/2+1);               % Single-sided
        df=fs/L;
        p=p/df;
        p(1)=0;
        Lp=length(p);
        fp=(0:df:(Lp-1)*df)';
        
        if strcmp(res,'LIN')
            % Determine smoothing window
            Nw=floor(2*(Lp-2)/(N+1)+1);
            if mod(Nw,2) == 0
                Nw=Nw-1;                % Ensure odd length
            end
            win=feval(winstr,Nw);
            % Ensure that the sum of the window is unity
            win = win/sum(win);
            P=zeros(N,1);
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
        Pyx(:,d,r)=P;
    end
end
