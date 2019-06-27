function DirString = nbr2dir(DirNumber)
% NBR2DIR   Convert numeric direction to string
%
%       DirString = nbr2dir(DirNumber)
%
%       DirString           String with e.g. 'X+' or '+X'
%
%       DirNumber           Number +/- 1, 2, 3 for +/- X, Y, Z
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if DirNumber == 0
    DirString='';
elseif DirNumber == 1
    DirString='X+';
elseif DirNumber == -1
    DirString='X-';
elseif DirNumber == 2
    DirString='Y+';
elseif DirNumber == -2
    DirString='Y-';
elseif DirNumber == 3
    DirString='Z+';
elseif DirNumber == -3
    DirString='Z-';
end