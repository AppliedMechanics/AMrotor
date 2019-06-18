function newx = smoothfilt(x,L)
%SMOOTHFILT Simple smoothing filter for time domain data
%
%       newx = smoothfilt(x,L)
%
%       x       Signal (should be time signal)
%       L       Length of smoothing filter in samples
%
% This command smooths time data with a rectangular amplitude characteristic
% with linear phase.


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2015-06-30 upgraded for 3D data
% This file is part of ABRAVIBE Toolbox for NVA

a=1;
b=1/L*ones(1,L);
[N,D,R]=size(x);
newx=zeros(N,D,R);
for d = 1:D
    if R > 1
        for r=1:R
            newx(:,d,r)=filtfilt(b,a,x(:,d,r));
        end
    else
        newx(:,d)=filtfilt(b,a,x(:,d));

    end
end