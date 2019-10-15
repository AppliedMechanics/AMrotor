function unvw58(fid,XData,Data,UnvHead); 
% function unvw58(fid,XData,Data,UnvHead);
% 
% This function writes one SDRC Universal File dataset, type 58 (Test Data).
% 
% Input:	fid	handle to Universal file
%		XData			contains x-axis for unevenly spaced data, or 0 if evenly spaced
%		Data			contains data in a column vector
%		UnvHead         contains all header values in a structure
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-01-10   Minor bugs fixed when Header not complete
%          1.2 2017-10-31   Fixed erroneous field Unv.RefDof to RefDir
% This file is part of ABRAVIBE Toolbox for NVA

dummy=fprintf(fid,'%6s\n','    -1');
dummy=fprintf(fid,'%6s\n','    58');
%---------------------------------------------------------------------------------		
% 
% Record 1 - 5, ID lines 
%-----------------------------------------------------------------------------------------------
dummy=fprintf(fid,'%s\n',UnvHead.Title);			% ID line 1
if isfield(UnvHead,'Title2')
    dummy=fprintf(fid,'%s\n',UnvHead.Title2);			% ID line 2
else
    dummy=fprintf(fid,'%s\n','NONE');
end
if isfield(UnvHead,'Date')                          % Added 2012-01-10
    dummy=fprintf(fid,'%s\n',UnvHead.Date);             % ID line 3 (Date)
else
    dummy=fprintf(fid,'%s\n','NONE');
end
if isfield(UnvHead,'Title3')
    dummy=fprintf(fid,'%s\n',UnvHead.Title3);			% ID line 4
else
    dummy=fprintf(fid,'%s\n','NONE');
end
if isfield(UnvHead,'Title4')
    dummy=fprintf(fid,'%s\n',UnvHead.Title4);			% ID line 5
else
    dummy=fprintf(fid,'%s\n','NONE');
end
%-----------------------------------------------------------------------------------------------
% Record 6 - DOF Identification
if ~isfield(UnvHead,'FuncId')
    UnvHead.FuncId=1;
end
if ~isfield(UnvHead,'ChannelNo')
    UnvHead.ChannelNo=1;
end
if ~isfield(UnvHead,'LoadCase')
    UnvHead.LoadCase=0;                     % Single point excitation
end
dummy=fprintf(fid,'%5i%10i%5i%10i',UnvHead.FunctionType,UnvHead.FuncId,UnvHead.ChannelNo,UnvHead.LoadCase);
if ~isfield(UnvHead,'RespId')
    UnvHead.RespId='NONE';
end
dummy=fprintf(fid,' %-10s%10i%4i',deblank(UnvHead.RespId),UnvHead.Dof,dir2nbr(UnvHead.Dir));
if ~isfield(UnvHead,'RefId')
    UnvHead.RefId='NONE';
end
if ~isfield(UnvHead,'RefDof')
    UnvHead.RefDof=0;
end
if ~isfield(UnvHead,'RefDir')
    UnvHead.RefDir=0;               % Bug fix 2017-10-31
end
dummy=fprintf(fid,' %-10s%10i%4i\n',deblank(UnvHead.RefId),UnvHead.RefDof,dir2nbr(UnvHead.RefDir));
%-----------------------------------------------------------------------------------------------
% Record 7 - Data Form
if isreal(Data)
    UnvHead.OrdDataType=2;
else
    UnvHead.OrdDataType=5;
end    
UnvHead.NoValues=length(Data);
if XData == 0                   % Even abscissa spacing
    UnvHead.xSpacing=1;
else
    UnvHead.xSpacing=0;
    UnvHead.xStart=XData(1);
    UnvHead.xIncrement=0;
end
if ~isfield(UnvHead,'zValue')
    UnvHead.zValue=0;
end
dummy=fprintf(fid,'%10i%10i%10i%13.5E%13.5E%13.5E\n',UnvHead.OrdDataType,UnvHead.NoValues,UnvHead.xSpacing,UnvHead.xStart,UnvHead.xIncrement,UnvHead.zValue);
%-----------------------------------------------------------------------------------------------
% Record 8 - Abscissa Data Characteristics
if ~isfield(UnvHead,'xSpecDataType')
    if UnvHead.FunctionType == 1 | UnvHead.FunctionType == 7 | UnvHead.FunctionType == 8
        UnvHead.xSpecDataType=17;       % Time
    else
        UnvHead.xSpecDataType=18;       % Frequency
    end
end
if ~isfield(UnvHead,'xLUnitsExp')
    UnvHead.xLUnitsExp=0;
end
if ~isfield(UnvHead,'xFUnitsExp')
    UnvHead.xFUnitsExp=0;
end
if ~isfield(UnvHead,'xTUnitsExp')
    UnvHead.xTUnitsExp=0;
end
if ~isfield(UnvHead,'xLabel')
    UnvHead.xLabel='NONE';
end
if ~isfield(UnvHead,'xUnit')
    if UnvHead.xSpecDataType == 17
        UnvHead.xUnit='Time';
    else
        UnvHead.xUnit='Frequency';
    end
end
dummy=fprintf(fid,'%10i%5i%5i%5i',UnvHead.xSpecDataType,UnvHead.xLUnitsExp,UnvHead.xFUnitsExp,UnvHead.xTUnitsExp);
dummy=fprintf(fid,' %-20s %-20s\n',deblank(UnvHead.xLabel),deblank(UnvHead.xUnit));
%-----------------------------------------------------------------------------------------------
% Record 9 - Ordinate (or ordinate numerator) Data Characteristic
if ~isfield(UnvHead,'OrdSpecDataType')
        UnvHead.OrdSpecDataType=0;       % 
end
if ~isfield(UnvHead,'OrdLUnitsExp')
    UnvHead.OrdLUnitsExp=0;
end
if ~isfield(UnvHead,'OrdFUnitsExp')
    UnvHead.OrdFUnitsExp=0;
end
if ~isfield(UnvHead,'OrdTUnitsExp')
    UnvHead.OrdTUnitsExp=0;
end
if ~isfield(UnvHead,'Label')
    UnvHead.Label='NONE';
end
if ~isfield(UnvHead,'Unit')
    UnvHead.Unit='NONE';
end
dummy=fprintf(fid,'%10i%5i%5i%5i',UnvHead.OrdSpecDataType,UnvHead.OrdLUnitsExp,UnvHead.OrdFUnitsExp,UnvHead.OrdTUnitsExp);
dummy=fprintf(fid,' %-20s %-20s\n',deblank(UnvHead.Label),deblank(UnvHead.Unit));
%-----------------------------------------------------------------------------------------------
% Record 10 - Ordinate Denominator Data Characteristic
if ~isfield(UnvHead,'DenSpecDataType')
        UnvHead.DenSpecDataType=0;       % 
end
if ~isfield(UnvHead,'DenLUnitsExp')
    UnvHead.DenLUnitsExp=0;
end
if ~isfield(UnvHead,'DenFUnitsExp')
    UnvHead.DenFUnitsExp=0;
end
if ~isfield(UnvHead,'DenTUnitsExp')
    UnvHead.DenTUnitsExp=0;
end
if ~isfield(UnvHead,'RefLabel')
    UnvHead.RefLabel='NONE';
end
if ~isfield(UnvHead,'RefUnit')
    UnvHead.RefUnit='NONE';
end
dummy=fprintf(fid,'%10i%5i%5i%5i',UnvHead.DenSpecDataType,UnvHead.DenLUnitsExp,UnvHead.DenFUnitsExp,UnvHead.DenTUnitsExp);
dummy=fprintf(fid,' %-20s %-20s\n',deblank(UnvHead.RefLabel),deblank(UnvHead.RefUnit));
%-----------------------------------------------------------------------------------------------
% Record 11 - Z-axis Data Characteristic
if ~isfield(UnvHead,'zSpecDataType')
        UnvHead.zSpecDataType=0;       % 
end
if ~isfield(UnvHead,'zLUnitsExp')
    UnvHead.zLUnitsExp=0;
end
if ~isfield(UnvHead,'zFUnitsExp')
    UnvHead.zFUnitsExp=0;
end
if ~isfield(UnvHead,'zTUnitsExp')
    UnvHead.zTUnitsExp=0;
end
if ~isfield(UnvHead,'zLabel')
    UnvHead.zLabel='NONE';
end
if ~isfield(UnvHead,'zUnit')
    UnvHead.zUnit='NONE';
end
dummy=fprintf(fid,'%10i%5i%5i%5i',UnvHead.zSpecDataType,UnvHead.zLUnitsExp,UnvHead.zFUnitsExp,UnvHead.zTUnitsExp);
dummy=fprintf(fid,' %-20s %-20s\n',deblank(UnvHead.zLabel),deblank(UnvHead.zUnit));
%-----------------------------------------------------------------------------------------------
% Data values - check for real or complex, and even or uneven data
FormatDescr1='%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E\n';	% Single precision
FormatDescr2='%20.12E%20.12E%20.12E%20.12E\n';			% Real/Complex, Even, Double Precision
FormatDescr3='%13.5E%20.12E%13.5E%20.12E\n';			% Real, Uneven, Double Precision
FormatDescr4='%13.5E%20.12E%20.12E\n';				% Complex, Uneven, Double Precision

if (UnvHead.xSpacing == 1)	% Even data, i.e. no x-axes values
    if (UnvHead.OrdDataType == 2)
        fprintf(fid,FormatDescr1,Data);				% Real, Single precision
        R=rem(UnvHead.NoValues,6);						% To see if needs forcing <CR>
    elseif (UnvHead.OrdDataType == 4)
        fprintf(fid,FormatDescr2,Data);				% Real, Double precision
        R=rem(UnvHead.NoValues,4);
    elseif (UnvHead.OrdDataType == 5)
        fprintf(fid,FormatDescr1,[real(Data),imag(Data)]');	% Complex, Single precision
        R=rem(2*UnvHead.NoValues,6);
    elseif (UnvHead.OrdDataType == 6)
        fprintf(fid,FormatDescr2,[real(Data),imag(Data)]');	% Complex, Double precision
        R=rem(2*UnvHead.NoValues,4);
    end
elseif (UnvHead.xSpacing == 0)	% Uneven data, i.e. x axes value prior to each data value
    if (UnvHead.OrdDataType == 2)
        fprintf(fid,FormatDescr1,[XData,Data]');			% Real, Single precision
        R=rem(2*UnvHead.NoValues,6);
    elseif (UnvHead.OrdDataType == 4)
        fprintf(fid,FormatDescr3,[XData,Data]');			% Real, Double precision
        R=rem(2*UnvHead.NoValues,4);
    elseif (UnvHead.OrdDataType == 5)
        fprintf(fid,FormatDescr1,[XData,real(Data),imag(Data)]');	% Complex, Single precision
        R=rem(3*UnvHead.NoValues,6);
    elseif (UnvHead.OrdDataType == 6)
        fprintf(fid,FormatDescr4,[XData,real(Data),imag(Data)]');	% Complex, Double precision
        R=rem(3*UnvHead.NoValues,3);
    end
end
if R ~= 0
    fprintf(fid,'\n');		% If not an integer number of rows were written: an extra <CR>
end
%-----------------------------------------------------------------------------------------------
dummy=fprintf(fid,'%6s\n','    -1');
