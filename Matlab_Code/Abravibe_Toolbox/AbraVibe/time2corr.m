function LastNumber = time2corr(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,Blocksize,RefChannel,DownSample,Type,start,stop)
% TIME2CORR    Process ABRAVIBE time data files into correlation function files
%
%   LastNumber = time2corr(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,Blocksize,RefChannel,DownSample,Type,start,stop)
%           LastNumber      Last number of last saved file
%           Prefix          Prefix for input files
%           StartNo         Number of first input file
%           StopNo          Number of last input file
%           OutPrefix       Prefix of output files
%           OutStartNo      First number for output files
%           Blocksize       Block size for correlation estimation if Welch
%                           is used. The number of lags in the CF if
%                           periodogram method is used
%           RefChannel      References, by file number, e.g. [1 7]. 
%           Downsample      (optional) Factor of downsampling, must be positive integer)
%           Type            (optional) Method for CF estimation, 'Welch'
%                           approach (default) or 'periodogram' approach
%           start           (optional) start sample in original data
%           stop            (optional) last sample in original data
%
%
% Typical application: Operational modal analysis, OMA
% Correlation function can be collected into a matrix for processing by DATA2HMTRX
% by specifying FunctionType = [7 8] 
%
% See also  TIME2SPEC

% Copyright (c) 2014 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version:  1.0 2015-12-06 Harmonized with other toolbox commands
% This file is part of ABRAVIBE Toolbox for NVA
% Thanks to Esben Orlowitz for initial version

OutFileNumber=OutStartNo;
if nargin < 8
    DownSample=0;
    Type='Welch';
elseif nargin<9
    Type='Welch';
end


h=waitbar(0,'Computing Correlation Functions...','Name','Time2corr');

for RefFileNo=1:length(RefChannel)
    waitbar(RefFileNo/length(RefChannel))
% If cross-correlations are requested, load reference channel
    if RefChannel(1) ~= 0      
        RefFileName=strcat(InPrefix,int2str(RefChannel(RefFileNo)),'.mat');
        if exist(RefFileName,'file') ==2
            load(RefFileName,'-mat')
            if exist('start','var')
                Data=Data(start:stop);
            end
            if exist('DownSample','var') & DownSample > 1
                fprintf('Downsampling by factor %i\n',DownSample)
                RefData=resample(Data,1,DownSample);
            else
                RefData=Data;
            end
            RefHeader=Header;
            clear Data Header
        end
    end
    
    FileNoVector=StartNo:StopNo;
    for fileno=1:length(FileNoVector)
        FileName=strcat(InPrefix,int2str(FileNoVector(fileno)),'.mat');
        if exist(FileName,'file') == 2
            load(FileName,'-mat')
            if exist('start')
                Data=Data(start:stop);
            end
            if exist('DownSample') & DownSample > 1
                Header.xIncrement=Header.xIncrement*DownSample;
                Data=resample(Data,1,DownSample);
                fs=1/Header.xIncrement/DownSample;
            else
                fs=1/Header.xIncrement;
            end
            if strcmp(upper(Type),'periodogram')
                if RefChannel(1) ~= 0
                    fs=1/Header.xIncrement;
                    Ryx = axcorrp(Data,RefData,fs,0);
                else    % Only autocorrelations requested
                    Ryx = axcorrp(Data,Data,fs,0);
                end
                Ryx=Ryx(1:Blocksize);
            else % Welch's method
                if RefChannel(1) ~= 0
                    Ryx = axcorrp(Data,RefData,fs,Blocksize);
                else        % Only autocorrelations requested
                    Ryx = axcorrp(Data,Data,fs,Blocksize);
                end
            end
            if fileno==1
                DataLength=length(Data);
            end
            clear Data
            
            Data=Ryx;
            if RefChannel(1) == 0
                Header.FunctionType=7;
            else
                if RefHeader.Dof==Header.Dof
                    Header.FunctionType=7;
                else
                    Header.FunctionType=8;
                end
                Header.RefDof=RefHeader.Dof;
                Header.RefDir=RefHeader.Dir;
            end
            Header.NoValues=length(Data);
            Header.Blocksize=Blocksize;
            if isfield(Header,'SeqNo')
                Header=rmfield(Header,'SeqNo');
            end
            if isfield(Header,'RespId')
                Header=rmfield(Header,'RespId');
            end
            if isfield(Header,'Date')
                Header.OriginalDate=Header.Date;
                Header.Date=date(now);
            end
            if isfield(Header,'Unit')
                Header.Unit=strcat('(',Header.Unit,')^2');
            end
            FileName=strcat(OutPrefix,int2str(OutFileNumber));
            save(FileName,'Data','Header')
            
            clear Data Header Ryx
        end
        OutFileNumber=OutFileNumber+1;
    end
end
LastNumber=OutFileNumber-1;
close(h)

