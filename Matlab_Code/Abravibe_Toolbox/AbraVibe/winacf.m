function Aw = winacf(w);
%WINACF Calculate amplitude correction factor of time window
%
%       Aw = winacf(win)
%
%       Aw          Amplitude correction factor (=2 for Hanning window)
%
%       w           Time window as column vector

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Aw=length(w)/sum(w);
