function [XData,Data,UnvHead] = unv_rb58(fid,FuncIdLine); 
% UNV_RB58    Read a binary universal file record 58b
%
% function [XData,Data,UnvHead] = unv_rb58(fid,FuncIdLine); 
%
% This function reads one BINARY dataset, type 58b (Test Data).
% 
% Output:	
%       XData contains x-axis for unevenly spaced data, or 0 if evenly spaced
%		Data	contains data in a column vector
%		UnvHead contains a struct with all header values
%

% Copyright (c) 2016 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2016-02-06 
% This file is part of ABRAVIBE Toolbox for NVA

XData=0;					% In case not used later
%---------------------------------------------------------------------------------		
% 
% Special Binary format 58 header, first row
%-----------------------------------------------------------------------------------------------
ByteOrderMethod=str2num(FuncIdLine(8:13));	% 1=little 2=big endian
FloatMethod=str2num(FuncIdLine(14:19));		% 1=DEC VMS, 2=IEEE 754 (Unix), 3=IBM 5/370
NoALines=str2num(FuncIdLine(20:31));        % Number of ASCII Lines below
NoBytes=str2num(FuncIdLine(32:43));			% Number of bytes after the ASCII lines
%---------------------------------------------------------------------------------		
% 
% Check that data is for Windows NT - this interface only supports ByteOrder=1 FloatMethod=2 
%-----------------------------------------------------------------------------------------------
if FloatMethod ~= 2
   error('This Binary UNV file has a format not supported by this interface');
end
% 
% Record 1 - 5, ID lines 
%-----------------------------------------------------------------------------------------------
UnvHead.Title=fgetl(fid);			% ID line 1
UnvHead.Title2=fgetl(fid);          % Ditto 2
UnvHead.Date=fgetl(fid);			% ID line 3, normally date and time
UnvHead.Title3=fgetl(fid);			% ...
UnvHead.Title4=fgetl(fid);
	
% Record 6 - DOF Identification
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.FunctionType=sscanf(L(1:5),'%i');    % Function Type
UnvHead.FuncId=sscanf(L(6:15),'%i');         % Function ID Number
UnvHead.SeqNo=sscanf(L(16:20),'%i');         % Version or Sequence Number
UnvHead.LoadCase=sscanf(L(21:30),'%i');      % Load Case ID Number
Dummy=sscanf(L(31),'%s');                    % Blank
UnvHead.RespId=sscanf(L(32:41),'%s');		 % Response Entity Name
UnvHead.Dof=sscanf(L(42:51),'%i');           % Response No
TmpDir=sscanf(L(52:55),'%i');                % Response Direction
UnvHead.Dir=nbr2dir(TmpDir);                 % Response Direction
Dummy=sscanf(L(56),'%s');                    % Blank
UnvHead.RefId=sscanf(L(57:66),'%s');		 % Reference Entity Name
UnvHead.RefDof=sscanf(L(67:76),'%i');        % Reference Node Number
TmpDir=sscanf(L(77:80),'%i');                % Reference Direction
UnvHead.RefDir=nbr2dir(TmpDir);              % Reference Direction

% Record 7 - Data Form
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.OrdDataType=sscanf(L(1:10),'%i');		% Ordinate Data Type (real or imaginary)
UnvHead.NoValues=sscanf(L(11:20),'%i');         % No Data Pairs (uneven), or Values (even)
UnvHead.xSpacing=sscanf(L(21:30),'%i'); 		% Abscissa Spacing (even or uneven)
UnvHead.xStart=sscanf(L(31:43),'%g');           % Abscissa minimum
UnvHead.xIncrement=sscanf(L(44:56),'%g');       % Abscissa increment
UnvHead.ZValue=sscanf(L(57:69),'%g');           % Z-axis value

% Record 8 - Abscissa Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.xSpecDataType=sscanf(L(1:10),'%i');     % Specific Data Type
UnvHead.xLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.xFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.xTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.xLabel=sscanf(L(27:46),'%s');           % Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.xUnit=sscanf(L(48:end),'%s');           % Axis Units Label

% Record 9 - Ordinate Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.OrdSpecDataType=sscanf(L(1:10),'%i');   % Specific Data Type
UnvHead.OrdLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.OrdFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.OrdTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.Label=sscanf(L(27:46),'%s');            % Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.Unit=sscanf(L(48:end),'%s');            % Axis Units Label

% Record 10 - Denominator Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.DenSpecDataType=sscanf(L(1:10),'%i');   % Specific Data Type
UnvHead.DenLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.DenFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.DenTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.RefLabel=sscanf(L(27:46),'%s');         % Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.RefUnit=sscanf(L(48:end),'%s');         % Axis Units Label

% Record 11 - Z-axis Data Characteristics
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
UnvHead.ZSpecDataType=sscanf(L(1:10),'%i');     % Specific Data Type
UnvHead.ZLUnitsExp=sscanf(L(11:15),'%i');		% Length Units Exponent
UnvHead.ZFUnitsExp=sscanf(L(16:20),'%i');		% Force Units Exp.
UnvHead.ZTUnitsExp=sscanf(L(21:25),'%i');		% Temp. Units Exp.
Dummy=sscanf(L(26),'%s');
UnvHead.ZLabel=sscanf(L(27:46),'%s');           % Axis Label
Dummy=sscanf(L(47),'%s');
UnvHead.ZUnit=sscanf(L(48:end),'%s');           % Axis Units Label

%-----------------------------------------------------------------------------------------------
% Read binary data and decode it
if ByteOrderMethod == 1
    MachineFormat='l';  % Little endian
else
    MachineFormat='b';  % Big endian
end
if UnvHead.OrdDataType == 2 | UnvHead.OrdDataType == 5
    Precision='single';
    bpn=4;                  % Bytes per number
else
    Precision='double';
    bpn=8;
end
A=fread(fid,NoBytes/bpn,Precision,MachineFormat);
if UnvHead.OrdDataType == 2 | UnvHead.OrdDataType == 4  % Real Data
    Data=A;
else
    Data=A(1:2:end)+j*A(2:2:end);
end
%-----------------------------------------------------------------------------------------------
F_id=fscanf(fid,'%i',1);			% Last -1 of dataset 58

