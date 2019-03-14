function Be = winenbw(w);
%WINENBW Calculate equivalent noise bandwidth of time window
%
%        Be = winenbw(w)
%
%        Be         Normalized equivalent noise bandwidth (=1.5 for Hanning window)
%
%        w          Time window in column vector
%
% See also   winacf ahann aflattop

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Be=length(w)*sum(w.^2)/sum(w)^2;
