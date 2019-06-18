function newx = winsmooth(x,w)
%WINSMOOTH Smooth data with any smoothing window
%
%       newx = smoothfilt(x,w)
%
%       x       Signal (can be time signal, frequency spectrum, rpm signal etc.)
%       w       Smoothing window, should be odd length!
%
% This command smooths time data with a rectangular amplitude characteristic
% with linear phase.


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

w=w/sum(w);
[N,D,R]=size(x);
newx=zeros(N,D,R);
for d = 1:D
    if R > 1
        for r=1:R
            newx(:,d,r)=conv(x(:,d,r),win);
        end
    else
        newx(:,d)=conv(x(:,d),win);
    end
end