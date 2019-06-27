function dasy2abra(FileName,Prefix,FirstNo,OutputType)
% DASY2ABRA   Import DASYLab ASCII file format to ABRAVIBE files
%
%       dasy2abra(FileName,Prefix,FirstNo,OutputType)
%
%       FileName    % Filename of DASYLab file, without extension (.ASC)
%       Prefix      String with file name prefix
%       StartNo     First file number of input files
%       OutputType  'abravibe' (default), or 'impact'
%
% If the OutputType is 'impact', then the data in the DASYLab file is
% stored as an .imptime file (see help for IMPACTGUI), and the force is
% assumed to be on the first channel. If OutputType is any other string,
% the data are stored into separate ABRAVIBE files.
%
% NOTE! Only time waveforms are supported. Data are checked for being time
% format.
%

% Copyright (c) 2009-2014 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2014-07-16
% This file is part of ABRAVIBE Toolbox for NVA

% This function was developed for DASYLab version 10.00.00

% Parse input parameters
if nargin == 3
    OutputType='ABRAVIBE';
elseif nargin == 4
    OutputType=upper(OutputType);
else
    error('wrong number of input parameters! Must be 3 or 4')
end

% Add extension to file and open it
FileName=strcat(FileName,'.ASC');
if exist(FileName,'file') == 2
    fid=fopen(FileName,'r');
else
    error('File does not exist!')
end

% Read header
L=fgetl(fid);
I=findstr(L,'DASYLab');
if isempty(I)
    error('File is not a DASYLab file!')
end
% Read line 2
L=fgetl(fid);   % Ignore line with Worksheet name
% Read line 3, date
L=fgetl(fid);
I=findstr(L,':');
I2=findstr(L,'"');
Date=L(I(1)+1:I2(end)-1);
% Read line 4, Blocksize
L=fgetl(fid);
I=findstr(L,':');
Blocksize=str2num(L(I+1:end));
% Read line 5, Delta x
L=fgetl(fid);
I=findstr(L,':');
I2=length(deblank(L));       % Go backwards to remove string at end
while isempty(str2num(L(I2)))
    I2=I2-1;
end
xIncrement=str2num(L(I+1:I2+1));
% Read line 6, Number of channels
L=fgetl(fid);
I=findstr(L,':');
NumberChannels=str2num(L(I+1:end));
% Read line 7, empty line
L=fgetl(fid);
% Read line 8, x axis unit
L=fgetl(fid);
I=findstr(L,';');
xaxisUnit=L(I+1:end);
% Read line 9, x axis unit
L=fgetl(fid);
I=findstr(L,';');
Type=L(I+1:end);
if isempty(findstr(upper(L),'TIME'))
    error('File does not seem to contain time data!')
end
% Read line 10, Y axis DOFs
L=fgetl(fid);
I=findstr(L,char(9));
I(length(I)+1)=length(L)+1;
for n = 1:NumberChannels
    DofDir{n}=L(I(n)+1:I(n+1)-1);
    if isempty(findstr(DofDir{n},'-')) % obviously + direction, DL does not use +
        DofDir{n}=strcat(DofDir{n},'+');
    end
end
% Read line 11, Y axis units
L=fgetl(fid);
I=findstr(L,char(9));
I(length(I)+1)=length(L)+1;
for n = 1:NumberChannels
    Units{n}=strtrim(L(I(n)+1:I(n+1)-1));
end
% Read line 12, dummy line
L=fgetl(fid);
% Read line 13, Labels
L=fgetl(fid);
I=findstr(L,char(9));
I(length(I)+1)=length(L)+1;
for n = 1:NumberChannels
    Labels{n}=L(I(n)+1:I(n+1)-1);
end
% Read data into vector
L=fscanf(fid,'%f');
% Split data into each channel; skip time axis which is first 'column'
for n=2:NumberChannels+1
    Data{n-1}=L(n:NumberChannels+1:end);
end

% Put data into ABRAVIBE .imptime format
for n=1:length(Data)
    Header(n)=makehead(1,Data{n},xIncrement);
    Header(n).Date=Date;
    Header(n).Title='Imported from DASYLab format by DASY2ABRA';
    Header(n).Unit=Units{n};
    nDofDir=dofdir2n(DofDir{n});
    [Header(n).Dof,Header(n).Dir]=n2dofdir(nDofDir);
    Header(n).Dir=nbr2dir(Header(n).Dir);
    Header(n).Label=Labels{n};
end

if ~strcmp(OutputType,'IMPACT')
    DataSave=Data;
    HeaderSave=Header;
    clear Data Header
    for n=1:length(DataSave)
        Data=DataSave{n};
        Header=HeaderSave(n);
        FileName=strcat(Prefix,num2str(FirstNo+n-1));
        fprintf('Saving file %s...\n',FileName)
        save(FileName,'Data','Header')
    end
else
    FileName=strcat(Prefix,num2str(FirstNo),'.imptime');
    fprintf('Saving file %s...\n',FileName)
    save(FileName,'Data','Header')
end




