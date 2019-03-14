function db10 = db10(y,ref);
% DB10      Calculate dB for power data (units squared)
%
%           db10 = db10(y, ref);
%
%           db10        dB value
%           
%           y           Data (with units of squared type, e.g. Pa^2)
%           ref         dB reference value (4e-10 for sound pressure)
%
% If no reference is given, 1 is used.
%
% See also DB20

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1,				% Use 1 as reference
   db10=10*log10(abs(y));
elseif nargin == 2,
   db10=10*log10(abs(y)/ref);
end
