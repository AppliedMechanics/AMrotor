function [p,V] = ir2pmitd(h,fs,Nlines,MaxModes,MIF,f)
%ir2MITD Multi-reference Ibrahim Time domain MDOF method for OMA parameter extraction
%
%       [p,V] = ir2pmitd(h,fs,Nlines,MaxModes,MIF,f)
%
%       p           Vector with complex poles with positive imaginary part
%       V           Unscaled mode shapes in columns
%
%       h           IRF matrix with any format (accelerance or other), N-by-D-by-R
%       fs          Sampling frequency
%       Nlines      Number of values in h(t) used for estimation, normally
%                   50-100
%       MaxModes    Maximum number of modes, limit for stabilization
%                   diagram
%       MIF         Mode indicator function, e.g. a PSD
%       f           Frequency axis for MIF
%
% This function plots a stabilization diagram with the mif function overlaid
% where you can select the poles interactively.
% Note that this function computes unscaled mode shapes.
%
% See inside file for some parameters you can hardcode to control behavior.
%
% See also FRF2PTIME

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-01-19
%          1.1 2018-05-20 Updated to call new stabilization diagram GUI
% This file is part of ABRAVIBE Toolbox for NVA

%=========================================================================
% Compute MIF function for overlay in stability diagrams
%=========================================================================
if nargin == 4
    [n,m,r]=size(h);
    if m > 1
        MIF=sum(abs(fft(h(:,:,1)))')';
    else
        MIF=abs(fft(h));
    end
    f=(0:fs/length(MIF):fs/2)';

    MIF=MIF(1:length(MIF)/2+1);
    MIF=smoothfilt(MIF,20);
    MIF=log(MIF);
    MIF=MIF-min(MIF(10:end));
    MIF=MIF/max(MIF(20:end));
elseif nargin == 6   % If both MIF and f given
    MIF=log(MIF);
    MIF=MIF-min(MIF(10:end));
    MIF=MIF/max(MIF(20:end));
    % Check if frequency increment is the same as for h()
    % If not, interpolate MIF and f onto a new frequency axis
%     df=fs/length(h);
%     if df ~= f(2)-f(1)
%         fold=f;
%         f=(0:fs/length(h):fs/2)';
%         MIF=interp1(fold,MIF,f);
%     end
else
    error('Wrong number of input parameters');
end

%=========================================================================
% Make initial calculations and frequency selection
%=========================================================================
[N,D,R]=size(h);

%=========================================================================
% Start parameter estimation
%=========================================================================
% This is an implementation of a multi-reference technique based on
% the Ibrahim Time Domain method. It computes both poles and mode
% shapes with a stabilization diagram in which poles can be chosen.
% Closely spaced or repeated modes can be computed with this technique.

% Build block Hankel matrix of order 2*MaxModes
% nr=2*MaxModes;  % 
nr=Nlines/2;      % 2016-03-18 Fixed to be in line with input params;
nc=nr;
% Build the block Hankel matrices at times t and t+dt (H1 and H2, respectively)
H1=h2hankel(h,nc,nr,1);
H2=h2hankel(h,nc,nr,2);
% Compute SVD of H1 for compression
[U,S,V]=svd(H1);
% Loop through model orders
for Np = 2:2:2*MaxModes      % Np is number of poles (2 per mode)
    % Reduce matrices to size Np
    Up=U(1:D*nr,1:Np);
%     Sp=S(1:Np,1:Np);
%     Vp=V(1:R*nc,1:Np);
    H1p=Up'*H1;
    H2p=Up'*H2;
    % Build compressed system matrix
    Aprime=(H2p*H1p')*pinv(H1p*H1p');
    % Solve eigenvalues and conv to poles
    [Vp,Dp]=eig(Aprime);
    Dp=diag(Dp);
    poles=fs*log(Dp);
    % Expand mode shapes
    Ve=Up*Vp;
    % Save to arrays
    NoPoles(Np/2)=Np/2;
    Poles{Np/2}=poles;
    ModeShape{Np/2}=Ve(1:D,:);
end
% Adjust frequencies for offset due to limited frequency range
fOffset=0;
for Order=1:MaxModes
    for n=1:length(Poles{Order})
        Sign=sign(imag(Poles{Order}(n)));
        wr=abs(Poles{Order}(n))+2*pi*fOffset;
        zr=abs(real(Poles{Order}(n)))/wr;
        Poles{Order}(n)=-zr*wr+j*Sign*wr*sqrt(1-zr^2);
    end
end
[p,SelOrder]=sdiagramnew(f,Poles,NoPoles,MIF);        % Select poles in stability diagram

% Find mode shapes corresponding to the selected poles
clear V
for n = 1:length(p)
    o_idx = find(NoPoles == SelOrder{n});           % which order was clicked?
    [m,p_idx]=min(Poles{o_idx} - p(n));             % Closest pole
    V(:,n)=ModeShape{o_idx}(:,p_idx);
end
