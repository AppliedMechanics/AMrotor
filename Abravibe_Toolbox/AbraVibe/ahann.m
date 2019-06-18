function w = ahann(N);
%AHANN Calculate a Hanning window
%
%           w = ahann(N);
%
%           w           Hanning time window
%
%           N           Blocksize, length of w
%
% Calculates a (correct!) Hanning window with length(N), in a column 
% vector. The ENBW is 1.5*df.
%
% See also aflattop winacf winenbw


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

a0=.5;
a1=.5;
t=(0:pi/N:pi-pi/N)';
w=a0-a1*cos(2*t);
