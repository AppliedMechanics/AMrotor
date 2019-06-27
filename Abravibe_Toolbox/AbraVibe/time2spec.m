function LastNumber = time2spec(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,Blocksize,RefChannel,DownSample,Type,start,stop)
% TIME2CORR    Process ABRAVIBE time data files into spectral density function files
%
%   LastNumber = time2corr(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,Blocksize,RefChannel,DownSample,Type,start,stop)
%           LastNumber      Last number of last saved file
%           Prefix          Prefix for input files
%           StartNo         Number of first input file
%           StopNo          Number of last input file
%           OutPrefix       Prefix of output files
%           OutStartNo      First number for output files
%           Blocksize       Block size. For Type='linspec' you can specify
%                           a window by, for example, aflattop(2048) 
%           RefChannel      References, by file number, e.g. [1 7]. 0 if no
%                           references (to produce autospectra only)
%           Downsample      (optional) Factor of downsampling, must be positive integer)
%           Type            (optional) Spectrum scaling, 'linspec', or 'psd'
%           start           (optional) start sample in original data
%           stop            (optional) last sample in original data
%
% If a reference channel (or several) is specified, then phased spectra are calculated
% with reference to the reference channel(s)
%
% Typical application: general frequency analysis, ODS
% 
% See also   TIME2CORR

% Copyright (c) 2018 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version:  1.0 2018-05-12 
% This file is part of ABRAVIBE Toolbox for NVA

OutFileNumber=OutStartNo;
if nargin < 8
    DownSample=0;
    Type='PSD';
elseif nargin<9
    Type='PSD';
end
if isscalar(Blocksize)
    if strcmp(upper(Type),'LINSPEC')
        Blocksize=ahann(Blocksize);
        ENBW=enbw(Blocksize);
    end
end

h=waitbar(0,'Computing Spectra...','Name','Time2spec');

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
    else
        RefHeader=0;
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
                fs=1/Header.xIncrement;
            else
                fs=1/Header.xIncrement;
            end
            if strcmp(upper(Type),'PSD')
                if RefChannel(1) ~= 0
                    fs=1/Header.xIncrement;
                    [Gyx,f] = acsdw(Data,RefData,fs,Blocksize);
                    Header.xIncrement=f(2);
                else    % Only autospectra requested
                    [Gyx,f] = apsdw(Data,fs,Blocksize);
                    Header.xIncrement=f(2);
                end
            else % linear spectra
                M=floor(length(Data)/length(Blocksize));
                fs=1/Header.xIncrement;
                if RefChannel(1) ~= 0
                    [Gyx,f] = alinspecp(Data,RefData,fs,Blocksize,2*M-1,50);
                    Header.xIncrement=f(2);
                else        % Only autocspectra requested
                    [Gyx,f] = alinspec(Data,fs,Blocksize,2*M-1,50);
                    Header.xIncrement=f(2);
                end
                Header.TimeWindowEnbw=ENBW;
            end
            if fileno==1
                DataLength=length(Data);
            end
            clear Data
            
            Data=Gyx;
            if strcmp(upper(Type),'PSD')
                Header.FunctionType=functype('psd');
            else
                Header.FunctionType=functype('spectrum');
            end
            if RefHeader ~= 0
                if RefHeader.Dof==Header.Dof
                else
                    Header.RefDof=RefHeader.Dof;
                    Header.RefDir=RefHeader.Dir;
                end
            end
            Header.NoValues=length(Data);
            if isfield(Header,'SeqNo')
                Header=rmfield(Header,'SeqNo');
            end
            if isfield(Header,'RespId')
                Header=rmfield(Header,'RespId');
            end
            if isfield(Header,'Date')
                Header.OriginalDate=Header.Date;
                Header.Date=datestr(now);
            end
            if isfield(Header,'Unit')
                if strcmp(upper(Type),'PSD')
                    Header.Unit=strcat('(',Header.Unit,')^2');
                end
            end
            FileName=strcat(OutPrefix,int2str(OutFileNumber));
            save(FileName,'Data','Header')
            
            clear Data Header Gyx
        end
        OutFileNumber=OutFileNumber+1;
    end
end
LastNumber=OutFileNumber-1;
close(h)

