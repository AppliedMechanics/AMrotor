function   LastFile = abra2imp(Prefix,StartNo,StopNo,NoAccels,OutPrefix,FirstOutNo)
% ABRA2IMP   Convert general ABRAVIBE time data files to .imptime format
%
%       LastFile = abra2imp(Prefix,StartNo,StopNo,NoAccels,OutPrefix,FirstOutNo)
%
%       LastFile    Last file number of the output files
%
%       Prefix      String with file name prefix
%       StartNo     First file number of input files
%       StopNo      Last file number of input files
%       NoAccels    Number of accelerometer channels used in impact test
%                   Default = 1
%       OutPrefix   String with prefix of output files
%       FirstOutNo  Number of first output file (Default = StartNo)
%
% This command can be used if an impact test has been made where data was
% stored in general ABRAVIBE files, i.e. one file per time data channel.
% The command puts the measurement of each impact location into one file
% with the .imptime format, consisting of the force and all accelerometers,
% see Section 3.1 in the manual.
% The output files are named OutPrefix<FirstOutNo>, OutPrefix<FirstOutNo+1>, ... with
% extension .imptime.
%
% Note! All files in the range StartNo to StopNo must exist!

% Copyright (c) 2014 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2014-01-27 
% This file is part of ABRAVIBE Toolbox for NVA

% Check input parameters
if nargin ~= 6
    NoAccels = 1;
    error('Wrong number of input parameters! Must be 6')
end
if mod((StopNo - StartNo +1),NoAccels+1) ~= 0
    error('StartNo and StopNo do not agree with number of accelerometer channels gives! \n')
end

% Start processing
NoChan=NoAccels+1;
OutNo=FirstOutNo;
n=StartNo;
% while n <= StopNo
    OutFile=strcat(OutPrefix,int2str(OutNo),'.imptime');
    for m = 1:NoChan
        InFile=strcat(Prefix,int2str(n+m-1));
        load(InFile);
        OutData{m}=Data;
        OutHeader(m)=Header;
    end
    Data=OutData;
    Header=OutHeader;
    fprintf('Saving file %s...\n',OutFile);
    save(OutFile,'Data','Header','-mat')
    n=n+NoChan
    OutNo=OutNo+1;
% end

% save last file number saved
LastFile=OutNo-1;