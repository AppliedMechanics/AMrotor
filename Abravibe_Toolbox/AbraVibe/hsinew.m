function w = hsinew(N);
% HSINEW     Calculate half sine time window
%
%           w = hsinew(N);
%
%           w           Half sine time window
%
%           N           Blocksize, length of w
%
%
% See also aflattop ahann winacf winenbw


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

t=(0:pi/N:pi-pi/N)';
w=sin(t);
