function DirNumber = dir2nbr(DirString)
% DIR2NBR   Convert Header direction string to number
%
%       DirNumber = dir2nbr(DirString)
%
%       DirNumber           Number +/- 1, 2, 3 for +/- X, Y, Z
%       DirString           String with e.g. 'X+' or '+X'
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

DirString=upper(DirString);
if strcmp(DirString,'X+') || strcmp(DirString,'+X')
    DirNumber=1;
elseif strcmp(DirString,'X-') || strcmp(DirString,'-X')
    DirNumber=-1;
elseif strcmp(DirString,'Y+') || strcmp(DirString,'+Y')
    DirNumber=2;
elseif strcmp(DirString,'Y-') || strcmp(DirString,'-Y')
    DirNumber=-2;
elseif strcmp(DirString,'Z+') || strcmp(DirString,'+Z')
    DirNumber=3;
elseif strcmp(DirString,'Z-') || strcmp(DirString,'-Z')
    DirNumber=-3;
elseif strcmp(DirString,'RX+') || strcmp(DirString,'+RX')
    DirNumber=4;
elseif strcmp(DirString,'RX-') || strcmp(DirString,'-RX')
    DirNumber=-4;
elseif strcmp(DirString,'RY+') || strcmp(DirString,'+RY')
    DirNumber=5;
elseif strcmp(DirString,'RY-') || strcmp(DirString,'-RY')
    DirNumber=-5;
elseif strcmp(DirString,'RZ+') || strcmp(DirString,'+RZ')
    DirNumber=6;
elseif strcmp(DirString,'RZ-') || strcmp(DirString,'-RZ')
    DirNumber=-6;
else
    DirNumber=0;
end