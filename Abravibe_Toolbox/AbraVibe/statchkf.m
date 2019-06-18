function statchkf(Prefix,StartNo,StopNo,FileName)
%STATCHK Create standard statistics for time signal(s) in ABRAVIBE files
%
%           statchk(Prefix,StartNo,StopNo,FileName)
%
%           Prefix      Filename prefix
%           StartNo     First file number (i.e. file name is <prefix>StartNo
%           StopNo      Last file number. 
%           FileName    If this string is given, the output of statchkf is
%                       redirected to a log file FileName.log in the 
%                       current directory (or in the directory indicated in 
%                       the string FileName if a full path is given). 
%                       Also, the actual statistical vectors are stored in 
%                       mat file FileName.mat.
%
% This function performs some standard statistical analysis of time data in 
% ABRAVIBE files. Not all files in the range from StartNo to StopNo must exist,
% as only existing files are opened. Results are written to a log file, or,
% if FileName is not given, to the screen.
%
% No results are plotted by this function. See STATCHK for that purpose.
% 
% WARNING! This command will overwrite an existing log file with the name
% in FileName!
%
% See also STATCHK FRAMESTAT TESTSTAT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


if nargin == 3
       fid=1;
elseif nargin == 4
    fid=fopen(strcat(FileName,'.log'),'w');
elseif nargin > 4 | nargin < 3
   error('Wrong number of parameters!')
end

FileNumber=StartNo:StopNo;
FilePointer=1;
for n = 1:length(FileNumber)
    InFile=strcat(Prefix,int2str(FileNumber(n)),'.mat');
    if exist(InFile,'file') == 2
        load(InFile);
        FileNo(FilePointer)=n;
        m(FilePointer)=mean(Data);
        Sigma2(FilePointer)=var(Data);
        Sigma(FilePointer)=sqrt(Sigma2(FilePointer));
        Skewness(FilePointer)=askewness(Data);
        Kurtosis(FilePointer)=akurtosis(Data);
        RMS(FilePointer)=sqrt(1/length(Data)*sum(Data.^2));
        Crest(FilePointer)=max(abs(Data))./RMS(FilePointer);
        XMax(FilePointer)=max(Data);
        XMin(FilePointer)=min(Data);
        FilePointer=FilePointer+1;
    end
end

if fid ~= 1
    fprintf(fid,'Output of command STATCHKF\n');
    fprintf(fid,'Date: %s\n',datestr(now));
    fprintf(fid,'File Prefix: %s\n',Prefix);
end
fprintf(fid,'Statistical parameters:\n');
fprintf(fid,'============================\n');
[S,E]=sprintf('%5s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n','File #','Max','Min','Mean','Crest','RMS','Std dev',...
'Variance','Skewness','Kurtosis');
fprintf(fid,'%s',S);
for n=1:length(FileNo),
   S2=sprintf('%5d%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g',FileNo(n),XMax(n),XMin(n),...
   m(n),Crest(n),RMS(n),Sigma(n),Sigma2(n),Skewness(n),Kurtosis(n));  
   fprintf(fid,'%s\n',S2);
end

% 
if nargin == 4
    % 2012-01-14 next line changed to work better in Octave
   S=['save -mat ' strcat(FileName,'.mat') ' FileNo XMax XMin m Crest RMS Sigma Sigma2 Skewness Kurtosis'];
   eval(S)
   fclose(fid);
   fprintf('Data saved in mat file %s.mat\n',FileName)
end
