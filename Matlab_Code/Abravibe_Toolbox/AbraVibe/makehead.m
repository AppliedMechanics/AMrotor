function Header = makehead(FuncType,Data,dx)
% MAKEHEAD   Make an empty ABRAVIBE header structure
%
%       Header = makehead(FuncType,Data,dx)
%
%       Header      ABRAVIBE header structure, see DATAHELP
%
%       FuncType    Numerical function type, see FUNCTYPE
%       Data        Data vector to take number of data values from
%       dx          x axis increment (1/fs for time data)

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2014-03-02 Fixed bugs for compatibility with abrahead
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin == 1
    Data=0;
    dx=1;
elseif nargin == 2
    dx=1;
end

% General fields
Header.FunctionType = FuncType;     % Numeric field! see FUNCTYPE
Header.Date=datestr(now);
Header.Title='Empty ABRAVIBE header';

% Data dependent fields
Header.NoValues=length(Data);
Header.xStart=0;
Header.xIncrement=dx;

% Information fields
Header.Unit='EU';
Header.Dof=1;
Header.Dir='X+';
Header.Label='Label';

% Fields dependent on Function type
SpecTypes1=[2:3];        % Auto/Cross spectrum
if ~isempty(find(SpecTypes1 == Header.FunctionType))
    Header.NumberAverages=1;
    Header.OverlapPerc=0;
    ENBW=0;
elseif Header.FunctionType == 9     % PSD
    Header.NumberAverages=1;
    Header.OverlapPerc=0;
    ENBW=0;
    Header.Method='Welch';
    Header.SmoothLength=0;
    Header.SmoothWin='';
end

SpecTypes2=[3:6 8];      % 2-channel function
if ~isempty(find(SpecTypes2 == Header.FunctionType))
    Header.RefDof=1;
    Header.RefDir='X+';
end

end

