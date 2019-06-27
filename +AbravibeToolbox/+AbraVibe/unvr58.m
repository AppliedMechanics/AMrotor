function [XData,Data,UnvHead] = unvr58(fid); 
% UNVR58    Read SDRC universal file test data record
%
%       [XData,Data,UnvHead] = unvr58(fid); 
% 
% Output:	
%       XData contains x-axis for unevenly spaced data, or 0 if evenly spaced
%		Data	contains data in a column vector
%		UnvHead contains a struct with all header values
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2016-02-06 Fixed problem with title lines starting with blanks
% This file is part of ABRAVIBE Toolbox for NVA

XData=0;					% In case not used later
%---------------------------------------------------------------------------------		
% 
% Record 1 - 5, ID lines 
%-----------------------------------------------------------------------------------------------
ID_1=fgetl(fid);                    % ID line 1
if length(ID_1) == 0
   UnvHead.Title=fgetl(fid);		% Sometimes fscanf() in unvread leaves a <CR>
% elseif (isspace(ID_1(1)))
elseif isequal(isspace(ID_1),ones(1,length(ID_1)))   % Changed 2016-02-06: handles lines starting with blanks
   UnvHead.Title=fgetl(fid);		% If 58 in Function ID was followed by blanks
else
    UnvHead.Title=ID_1;
end
UnvHead.Title2=fgetl(fid);      	% Ditto 2
UnvHead.Date=fgetl(fid);			% ID line 3, normally date and time
UnvHead.Title3=fgetl(fid);			% ...
UnvHead.Title4=fgetl(fid);
	
% Record 6 - DOF Identification
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.FunctionType=sscanf(L(1:5),'%i');    % Function Type
UnvHead.FuncId=sscanf(L(6:15),'%i');          % Function ID Number
UnvHead.SeqNo=sscanf(L(16:20),'%i');                 % Version or Sequence Number
UnvHead.LoadCase=sscanf(L(21:30),'%i');		% Load Case ID Number
Dummy=sscanf(L(31),'%s');                  % Blank
UnvHead.RespId=sscanf(L(32:41),'%s');		% Response Entity Name
UnvHead.Dof=sscanf(L(42:51),'%i');             % Response No
TmpDir=sscanf(L(52:55),'%i');    % Response Direction
UnvHead.Dir=nbr2dir(TmpDir);    % Response Direction
Dummy=sscanf(L(56),'%s');                  % Blank
UnvHead.RefId=sscanf(L(57:66),'%s');			% Reference Entity Name
UnvHead.RefDof=sscanf(L(67:76),'%i');          % Reference Node Number
TmpDir=sscanf(L(77:80),'%i'); % Reference Direction
UnvHead.RefDir=nbr2dir(TmpDir); % Reference Direction

% Record 7 - Data Form
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.OrdDataType=sscanf(L(1:10),'%i');		% Ordinate Data Type (real or imaginary)
UnvHead.NoValues=sscanf(L(11:20),'%i');		% No Data Pairs (uneven), or Values (even)
UnvHead.xSpacing=sscanf(L(21:30),'%i'); 		% Abscissa Spacing (even or uneven)
UnvHead.xStart=sscanf(L(31:43),'%g');          % Abscissa minimum
UnvHead.xIncrement=sscanf(L(44:56),'%g');      % Abscissa increment
UnvHead.zValue=sscanf(L(57:69),'%g');          % Z-axis value

% Record 8 - Abscissa Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.xSpecDataType=sscanf(L(1:10),'%i');    % Specific Data Type
UnvHead.xLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.xFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.xTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.xLabel=sscanf(L(27:46),'%s');		% Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.xUnit=sscanf(L(48:end),'%s');         % Axis Units Label

% Record 9 - Ordinate Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.OrdSpecDataType=sscanf(L(1:10),'%i');    % Specific Data Type
UnvHead.OrdLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.OrdFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.OrdTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.Label=sscanf(L(27:46),'%s');		% Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.Unit=sscanf(L(48:end),'%s');         % Axis Units Label

% Record 10 - Denominator Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.DenSpecDataType=sscanf(L(1:10),'%i');    % Specific Data Type
UnvHead.DenLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.DenFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.DenTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.RefLabel=sscanf(L(27:46),'%s');		% Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.RefUnit=sscanf(L(48:end),'%s');         % Axis Units Label

% Record 11 - Z-axis Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.zSpecDataType=sscanf(L(1:10),'%i');     % Specific Data Type
UnvHead.zLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.zFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.zTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.zLabel=sscanf(L(27:46),'%s');           % Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.zUnit=sscanf(L(48:end),'%s');           % Axis Units Label

%-----------------------------------------------------------------------------------------------
% Data values - check for real or complex, and even or uneven data
if (UnvHead.xSpacing == 1)	% Even data, i.e. no x-axes values
   if (UnvHead.OrdDataType == 2)|(UnvHead.OrdDataType == 4)	% if real even data
      Data=fscanf(fid,'%g',UnvHead.NoValues);
   elseif (UnvHead.OrdDataType == 5)|(UnvHead.OrdDataType == 6) 	% if complex data
      dummy=fscanf(fid,'%g',[2,UnvHead.NoValues]);			% (..10) equals No. data PAIRS
      redummy=dummy(1,:)';
      imdummy=dummy(2,:)';
      Data=redummy+i*imdummy;
   else 
      disp('Error. Something is wrong in your universal file.')
      error('Record 7 field 1 must be 2, 4, 5 or 6.')
   end
else	% Uneven data, i.e. x axes value prior to each data value
    if (UnvHead.OrdDataType == 2)|(UnvHead.OrdDataType == 4), 			% if real even data
        dummy=fscanf(fid,'%g',[2,UnvHead.NoValues]);
        XData=dummy(1,:)';
        Data=dummy(2,:)';
    elseif (UnvHead.OrdDataType == 5)|(UnvHead.OrdDataType == 6), 	% if complex data
        dummy=fscanf(fid,'%g',[3,UnvHead.NoValues]);			% (..10) equals No. data PAIRS
        XData=dummy(1,:)';
        redummy=dummy(2,:)';
        imdummy=dummy(3,:)';
        Data=redummy+i*imdummy;
    else
        error('Error. File Format Error. A 2, 4, 5 or 6, expected for Record 7, field 1.')
    end
end
%-----------------------------------------------------------------------------------------------
F_id=fscanf(fid,'%i',1);		% Last -1 of dataset 58.
if (F_id == 0)                  % Some interfaces add extra zeros to the data, to get a 
   dummy=fgetl(fid);			% whole line at the end. If so, this part forces the last 
   F_id=fscanf(fid,'%i',1);		% line to end and reads the -1.
end		

