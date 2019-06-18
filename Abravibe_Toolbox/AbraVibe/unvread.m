function LastNo = unvread(FileName,Prefix,FirstNo,Type)
%UNVREAD Read a standard UNV file
%
%           LastNo = unvread(FileName,Prefix,FirstNo)
%
%           LastNo      File number of last file, 0 if no files were saved
%
%           FileName    Universal file name WITH extension
%           Prefix      Prefix string for output file names
%           FirstNo     File number for first file
%           Type        Numeric unv type to 'filter' out (see below)
%
% This function imports an (ASCII) Universal File, and puts data into ABRAVIBE
% formatted .mat files. Each file is named with the prefix and a running
% number, for example, if the prefix is 'abra', abra1, abra2,...
%
% The input variable Type can be set to (string) '15', '55', '58' or '58b',
% to read only records of the specified type. This is useful to get a
% subsequent range of files with the same type, if the universal file
% contains a mix of record types.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2016-02-06 Added support for binary universal file
%          1.2 2018-05-08 Fixed bug for uneven x axis data
% This file is part of ABRAVIBE Toolbox for NVA

%
fid=fopen(FileName);			% Open file
if fid == -1
    if strcmp(checksw,'MATLAB')
        FileName=uigetfile('*.*');
    else
        disp('Error opening file ');
        return
    end
end
if FileName ~= 0
    fid=fopen(FileName);
else
    error('No file selected')
end

dummy=fgetl(fid);						% Loop until First -1
while ((isempty(findstr(dummy,'-1'))) & ~feof(fid))
    disp('Looping to find a -1...')
    dummy=fgetl(fid);
end
if feof(fid)
    error('File Format Error. Not a Universal File.');
end

% FuncId=fscanf(fid,'%i',1);			% Function identifier
L=fgetl(fid);
if ~isempty(findstr(L,'58b'))
    FuncId='58b';
    FuncIdLine=L;                       % For later interpretation
else
    FuncId=sscanf(L,'%i',1)
end
skip=0;
FileNo=FirstNo;
%-------------------------------------------------------------------------------------
while ~feof(fid)
    OutFileName=strcat(Prefix,int2str(FileNo));
    if (FuncId == 58)
        %     Read one dataset type 58
        S=['Dataset ' num2str(FuncId) '. Reading...'];
        disp(S)
        [a b c]=unvr58(fid);			% a b c are XData, Data, Header
        XData=a;
        Data=b;
        Header=c;
        Header.OrgFileName=FileName;
        fprintf('Saving %s...\n',OutFileName)
        if XData ~= 0
            xAxis=XData;        % Bug fix 2018-05-08
            save(OutFileName,'xAxis','Data','Header')
        else
            save(OutFileName,'Data','Header')
        end
        FileNo=FileNo+1;
    elseif (FuncId == 55)
        % Read one dataset 55
        S=['Dataset ' num2str(FuncId) '. Reading...'];
        disp(S)
        [e f g]=unvr55(fid);			% Nodes, Shape, Header
        Nodes=e;
        Shape=f;
        Header=g;
        fprintf('Saving %s...\n',OutFileName)
        save(OutFileName,'Nodes','Shape','Header')
        FileNo=FileNo+1;
    elseif (FuncId == 15)					% Read one dataset type 15
        S=['Dataset ' num2str(FuncId) '. Reading...'];
        disp(S)
        Nodes = unvr15(fid);
        fprintf('Saving %s...\n',OutFileName)
        save(OutFileName,'Nodes','Nodes')
        FileNo=FileNo+1;
    elseif (FuncId == 82)					% Read one dataset type 15
        S=['Dataset ' num2str(FuncId) '. Reading...'];
        disp(S)
        [TLine,THeader] = unvr82(fid);
        fprintf('Saving %s...\n',OutFileName)
        save(OutFileName,'TLine','THeader')
        FileNo=FileNo+1;
    elseif strcmp(FuncId,'58b')
        S=['Dataset ' (FuncId) '. Reading...'];
        disp(S)
        [XData,Data,Header] = unvrb58(fid,FuncIdLine);
        fprintf('Saving %s...\n',OutFileName)
        if XData ~= 0
            save(OutFileName,'xAxis','Data','Header')
        else
            save(OutFileName,'Data','Header')
        end
        FileNo=FileNo+1;
        %   elseif (FuncId == )					% Add here for more fileset types
    else
        S=['Fileset ' num2str(FuncId) '. Skipping...'];
        disp(S)
        n=unv_skip(fid);
        skip=skip+1;
    end
    if ~feof(fid)
        dummy=fgetl(fid);					% Read until next fileset, if not EOF
        while (~feof(fid) & (isempty(findstr(dummy,'-1'))))	% Find -1 of next dataset
            dummy=fgetl(fid);						% Read down to next dataset identifier
        end
        if ~(feof(fid))
             dummy=fgetl(fid);
             if ~isempty(findstr(dummy,'58b'))
                 FuncId='58b';
                 FuncIdLine=dummy;           % For later interpretation
             else
                 FuncId=sscanf(dummy,'%i',1)
             end
        end
    end
end

if FileNo == FirstNo
    LastNo = 0;
else
    LastNo=FileNo-1;
end

fclose(fid);
