function w = aforcew(N,widthp,Type)
%AFORCEW Force window for impact testing
%
%       w = aforcew(N,widthp,Type)
%
%       w           Time window in column vector
%
%       N           Window length
%       widthp      Width in percent of N
%       Type        String 'Gaussian' bell (default), or 'Halfsine'
%
% Note: Before applying this window, care should be taken that the data
% sequence starts with zero, by executing x=x-x(1); if the force time
% history is in a column vector x.
%
% See also AEXPW IMP2FRF
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin == 2
    Type='GAUSSIAN';
elseif nargin == 3
    Type=upper(Type);
elseif nargin < 2
    error('Too few input parameters');
elseif nargin > 3
    error('Too many input parameters');
end

% The window is designed so that it goes smoothly from 1 to 0
% in the range N*widthp/100 to 2*N*widthp/100

if widthp < 50
    w=zeros(N,1);
    wl=round(widthp*N/100);         % Window length in samples
    tl=round(wl);                   % Taper length
    w(1:wl)=1;
    n=0:tl;
    if strcmp(Type,'GAUSSIAN')
        p=makepulse(2*tl,1,2*tl-1,Type);
        p=p(tl:end)/p(tl);
        w(wl:wl+tl)=p;
    elseif strcmp(Type,'HALFSINE')
        t=0.5*(1+cos(pi*n/tl));
        w(wl:wl+tl)=t;
    else
        error('Wrong value for Type')
    end
else
    w=ones(N,1);
end
