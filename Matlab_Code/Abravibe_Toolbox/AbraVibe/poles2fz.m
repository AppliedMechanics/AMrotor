function [fr,zr] = poles2fz(poles)
%POLES2FZ Convert poles to frequencies and relative damping
%
%       [fr,zr] = poles2fz(poles)
%
%       fr          Undamped natural (eigen-) frequencies, in vector
%       zr          Relative damping ratios, in vector same length as fr
%
%       poles       Complex poles in column vector
%


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

a=real(poles);
b=imag(poles);
wr=sqrt(a.^2+b.^2);     % This is more transparent than the equivalent wr=abs(poles).^2
fr=1/2/pi*wr;
zr=-a./wr;
