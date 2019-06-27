function db20 = db20(y,ref);
% DB20      Calculate dB for linear data (linear units)
%
%           db20 = db20(y, ref);
%
%           db20        dB value
%           
%           y           Data (with units of linear type, e.g. Pa)
%           ref         dB reference value (2e-5 for sound pressure)
%
% If no reference is given, 1 is used.
%
% See also DB10


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1,				% Use 1 as reference
   db20=20*log10(abs(y));
elseif nargin == 2,
   db20=20*log10(abs(y)/ref);
end
   