function phase = angledeg(H);
%ANGLEDEG Calculate angle in degrees for complex vector(s)
%
%           phase = angledeg(y);
%
%           phase       Phase angle
%
%           y           Complex vector(s). Each column treated separately
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


if isreal(H)
   error('Input vector must be complex!');
else
   phase = 180/pi*angle(H);
end
