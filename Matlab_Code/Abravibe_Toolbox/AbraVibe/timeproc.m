function LastNumber = timeproc(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,FunctionType,Settings)
% TIME2PROC    Process time data files into ABRAVIBE function files
%
%  *********** THIS FILE IS UNDER DEVELOPMENT AND MAY NOT WORK*********
%
%   LastNumber = timeproc(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,FunctionType,Settings)
%
%           LastNumber      Last number of last saved file
%           Prefix          Prefix for input files
%           StartNo         Number of first .imptime file
%           StopNo          Number of last .imptime file
%           OutPrefix       Prefix of output files
%           OutStartNo      First number for output files
%           FunctionType    Output function type(s), see function FUNCTYPE
%                           Specified either as number or short string.
%                           Currently supported: [8](cross correlations),
%                           9(PSD/CSD) (See NOTE below)
%           Settings        Struct with fields according to the
%                           FunctionType. See inside file for details of
%                           Settings fields for the various outputs
%
%
% Typical applications: Spectrum analysis, ODS, OMA
%
% NOTE! For correlation functions:
% Even though the function type to specify correlation functions is
% 8 (cross-correlation), the autocorrelation functions are stored with
% function type 7, which specifies autocorrelation. This means that to use
% data2hmtrx to import those files into a correlation function matrix for
% use in OMA appliations, you have to specify FunctionType as a vector [7 8]
%
% Fields for different FunctionTypes
% ALL function types:
%   OutputDirectory     Directory for output files. If not given, a defauls
%                       name PSD/CORR is used
%   Downsample          If existant, data are downsampled by this factor
%                       prior to the processing
%   RefChannels         References, by file number, e.g. [1 7], [2:7]. If
%                       not defined, or if = 0, only auto functions are computed
%                       for FunctionType=9.
%
% FOR PSDs/CSDs:
%   Blocksize       Blocksize for Welch method
%   Overlap         Overlap in Percentage. 50% is default if field not defined
%
% FOR CORR:
%   ProcType        'Welch' or 'PERIODOGRAM' (default)
%   BlockSize       Blocksize for Welch method. Maximum lag to store for 
%                   type 'PERIODOGRAM'. 1024 is default value in both cases
%   

%
% Copyright (c) 2015 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version:  1.0 2015-12-20
%
% This file is part of ABRAVIBE Toolbox for NVA

if nargin ~= 7
    error('Wrong number of input arguments!')
end

% Make FunctionType numeric, and check a valid function type is given
if ~isnumeric(FunctionType)
    FunctionType=functype(FunctionType);
    if FunctionType <= 0
        error('Wrong FunctionType!')
    end
elseif FunctionType <= 0 || isempty(ismember(FunctionType,[7 8 9]))
    error('Unsupported FunctionType!')
end

% Check Settings fields common to all function types
if ~isfield(Settings,'OutputDirectory')
    if FunctionType == 7 |FunctionType == 8
        Settings.OutputDirectory='CORR';
    else
        Settings.OutputDirectory='PSD';
    end
end
if ~isfield(Settings,'DownSample')
    Settings.DownSample=1;
end
if ~isfield(Settings,'RefChannels')
    Settings.RefChannels=0;
end


% Process data depending on FunctionType
if FunctionType == 8    % Correlation functions. NOTE! Even if 8 is specified as function type,
                        % the autocorrelations are stored with 7 in the Header. 
    % Check that valid parameters are available in the Settings struct
    if isfield(Settings,'ProcType')
        if strcmp(upper(Settings.ProcType),'WELCH')
            ProcType='WELCH';
        elseif strcmp(upper(Settings.ProcType),'PERIODOGRAM')
            ProcType='PERIODOGRAM';
        else
            error('Wrong ProcType for correlation functions!')
        end
    else
        Settings.ProcType='PERIODOGRAM';
    end
    if isfield(Settings,'Blocksize')
        N=Settings.Blocksize;
    else
        N=1024;
    end
if exist(Settings.OutputDirectory,'dir') ~= 7
        mkdir(Settings.OutputDirectory)
    end
    OutPrefix=fullfile(Settings.OutputDirectory,OutPrefix);
    LastNumber=time2corr(InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,N,Settings.RefChannels,Settings.DownSample,ProcType);
elseif FunctionType == 9        % PSDs and (maybe) CSDs
    % Check that valid fields are defined in the Settings struct.
%    if isfield(Settings,
end