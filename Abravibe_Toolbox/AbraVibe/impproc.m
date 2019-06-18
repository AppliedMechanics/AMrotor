function LastNumber = impproc(FreqLo,FreqHi,InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,SetupFile,Proc,fid)
%IMPPROC Impact time data processing
%
%           THIS FUNCTION IS OBSOLETE! Please check the new ImpactGui.m
%
%
%           LastNumber = impproc(FreqLo,FreqHi,InPrefix,StartNo,StopNo,OutPrefix,OutStartNo,SetupFile,Proc,fid)
%
%           LastNumber      Last number of last saved file
%
%           FreqLo          Lowest frequency for plots
%           FreqHi          Highest frequency for plots
%           InPrefix        Prefix for input files
%           StartNo         Number of first .imptime file
%           StopNo          Number of last .imptime file
%           OutPrefix       Prefix of output files
%           OutStartNo      Number of first output file
%           SetupFile       Impact processing setup file with analysis
%                           parameters, WITHOUT extension (.impsetup)
%           Proc            Processing type, 'manual' (default) lets user interact
%                           for each measurement; 'auto' implements processing for
%                           optimized coherence results
%                           If Proc is a vector with numbers, e.g. [1 2 3]
%                           those impacts will be used for processing
%
% FFT settings are defined in the setup file.
% Sequence with file names StartNo:StopNo can include non-existing file
% numbers, only existing files are read and processed
%
% See also IMPSETUP

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23 
%          1.1 2013-11-16  Fixed help text to fit syntax
%          1.2 2013-12-01  Fixed bug if setup file nonexistant
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 6
    Proc='MANUAL';
else
    if isnumeric(Proc)
        Triggers=Proc;
        Proc='SELECTION';
    else
        Proc=upper(Proc);
    end
end

SetupFileName=strcat(SetupFile,'.impsetup');
if exist(SetupFileName,'file') == 2
    load(SetupFileName,'-mat')
else
    fprintf('Setup file not found. Running with default parameters.')
    ImpSetup.TrigLevel=5;
    ImpSetup.PreTrigger=300;
    ImpSetup.N=4096;            % Fixed bug, renamed N 2013-12-01
    ImpSetup.ForceWidthp=5;
    Impsetup.ExpWinEnd=1;
end

% Start processing all files in sequence
if ~exist('fid','var')
    fid=1;                  % Print to screen if no file open
end

FileNoVector=StartNo:StopNo;
for fileno=1:length(FileNoVector)
    FileName=strcat(InPrefix,int2str(FileNoVector(fileno)),'.imptime');
    fprintf(fid,'\n******************************************\n')
    fprintf(fid,'Processing file: %s...\n',FileName)
    if exist(FileName,'file') == 2
        load(FileName,'-mat')
        fs=1/Header(1).xIncrement;
        clear x y
        D=length(Data)-1;       % Number responses
        x=Data{1};
        for k=1:D
            y(:,k)=Data{k+1};
        end
        if strcmp(Proc,'MANUAL')
            LoopSwitch=1;
            while LoopSwitch
                [H,f,C,Tff]=imp2frf(x,y,fs,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd);
                close all
                h=figure;
                subplot(2,1,1)
                semilogy(f,abs(H))
                for n=1:D
                    LegendArray{n}=strcat(headpstr(Header(n+1)),'/',headpstr(Header(1)));
                end
                legend(LegendArray)
                A=axis;
                grid
                axis([FreqLo FreqHi A(3) A(4)])
                subplot(2,1,2)
                plot(f,C)
                axis([FreqLo FreqHi 0 1])
                grid
                a=input('Try another choice of impacts? (y/n): ','s');
                a=upper(a);0
                if strcmp(a,'N')
                    LoopSwitch=0;
                else
                end
            end
            close all
            % Save results
            InHeader=Header;
            clear Header Data
            for k=1:D
                Header=InHeader(k+1);
                Header.RefDof=InHeader(1).Dof;
                Header.RefDir=InHeader(1).Dir;
                Header.Unit=strcat('(',InHeader(k+1).Unit,')/',InHeader(1).Unit);
                Header.FunctionType=4;
                Header.xIncrement=f(2);
                FileName=strcat(OutPrefix,'H',int2str(OutStartNo));
                Data=H(:,k);
                fprintf(fid,'Saving file %s...\n',FileName);
                save(FileName,'Data','Header')
                Header.Unit='';
                Header.FunctionType=6;
                FileName=strcat(OutPrefix,'C',int2str(OutStartNo));
                Data=C(:,k);
                save(FileName,'Data','Header')
                Header.FunctionType=30;
                Header.Unit=strcat('(',InHeader(1).Unit,')^2');
                Header.Dof=InHeader(1).Dof;
                Header.Dir=InHeader(1).Dir;
                Header=rmfield(Header,'RefDof');
                Header=rmfield(Header,'RefDir');
                FileName=strcat(OutPrefix,'F',int2str(OutStartNo));
                Data=Tff(:,k);
                save(FileName,'Data','Header')
                OutStartNo=OutStartNo+1;
            end
        elseif strcmp(Proc,'AUTO')
            TrigIdx=imptrig(x,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger);
            minCSum=1e10;
            minPair=[0 0];
            CSumIdx=1;
            IdxPair=[];
            % Find all CSums for pairs of impacts, and take lowest
            for ch=1:D;
                for l=1:length(TrigIdx)
                    Tidx1=TrigIdx(l);
                    for k=l+1:length(TrigIdx)
                        Tidx2=TrigIdx(k);
                        [H,f,C] = imp2frf2(x,y(:,ch),fs,ImpSetup.N,TrigIdx([l k]),0,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,0);
                        idx1=min(find(f>=FreqLo));
                        idx2=min(find(f>=FreqHi));
                        fidx=idx1:idx2;
                        CSum(CSumIdx)=(f(2)-f(1))*sum(1-C(fidx));
                        if CSum(CSumIdx) < minCSum;
                            minCSum=CSum(CSumIdx);
                            minPair=[Tidx1 Tidx2];
                        end
                        fprintf(fid,'Index pair %i: %i %i sum is: %f\n',CSumIdx,Tidx1,Tidx2,CSum(CSumIdx));
                        CSumIdx=CSumIdx+1;
                    end
                end
                fprintf(fid,'******************************************\n')
                fprintf(fid,'Lowest CSum: %f for indeces: \n',minCSum);
                fprintf(fid,'%i\n',minPair)
                fprintf(fid,'******************************************\n')
                % Start optimization loop
                disp('Starting optimization loop')
                idx=find(TrigIdx~=minPair(1) & TrigIdx~=minPair(2));
                for k=1:length(idx)
                    % If TrigIdx(k) not already in minPair, see if
                    % coherence improves by adding it
                    if ismember(minPair,TrigIdx(k)) == zeros(size(minPair))
                        Triggers=[minPair TrigIdx(k)];
                        [H,f,C,Tff] = imp2frf2(x,y(:,1),fs,ImpSetup.N,Triggers,0,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,0);
                        CSum=(f(2)-f(1))*sum(1-C(fidx));
                        if CSum < minCSum;
                            minCSum=CSum;
                            minPair=Triggers;
                            %                     fprintf('Adding Trigger %i\n',TrigIdx(k))
                        end
                    end
                end
                Triggers=minPair;           % Better name
                fprintf(fid,'Triggers for channel %i: \n\n',ch)
                fprintf(fid,'%i\n',Triggers)
                Triggers
                % Save H, f, C, and Tff
                [H,f,C,Tff] = imp2frf2(x,y(:,ch),fs,ImpSetup.N,Triggers,0,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,0);
                InHeader=Header; clear Header
                Header=InHeader(ch+1);
                Header.RefDof=InHeader(1).Dof;
                Header.RefDir=InHeader(1).Dir;
                Header.Unit=strcat('(',InHeader(ch+1).Unit,')/',InHeader(1).Unit);
                Header.FunctionType=4;
                Header.xIncrement=f(2);
                Header.Title='Optimized Processing';
                FileName=strcat(OutPrefix,'H',int2str(OutStartNo));
                Data=H;
                fprintf(fid,'Saving file %s...\n',FileName);
                save(FileName,'Data','Header')
                Header.Unit='';
                Header.FunctionType=6;
                FileName=strcat(OutPrefix,'C',int2str(OutStartNo));
                Data=C;
                save(FileName,'Data','Header')
                Header.FunctionType=30;
                Header.Unit=strcat('(',InHeader(1).Unit,')^2');
                Header=rmfield(Header,'RefDof');
                Header=rmfield(Header,'RefDir');
                FileName=strcat(OutPrefix,'F',int2str(OutStartNo));
                Data=Tff;
                save(FileName,'Data','Header')
                OutStartNo=OutStartNo+1;
                Header=InHeader;
            end
        elseif strcmp(Proc,'SELECTION')
            TrigIdx=imptrig(x,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger);
            [H,f,C,Tff] = imp2frf2(x,y,fs,ImpSetup.N,TrigIdx(Triggers),0,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,0);
            D=length(y(1,:));           % Number of responses (columns in H, C etc.)
            % Save results
            InHeader=Header;
            clear Header Data
            for k=1:D
                Header=InHeader(k+1);
                Header.RefDof=InHeader(1).Dof;
                Header.RefDir=InHeader(1).Dir;
                Header.Unit=strcat('(',InHeader(k+1).Unit,')/',InHeader(1).Unit);
                Header.FunctionType=4;
                Header.xIncrement=f(2);
                FileName=strcat(OutPrefix,'H',int2str(OutStartNo));
                Data=H(:,k);
                fprintf(fid,'Saving file %s...\n',FileName);
                save(FileName,'Data','Header')
                Header.Unit='';
                Header.FunctionType=6;
                FileName=strcat(OutPrefix,'C',int2str(OutStartNo));
                Data=C(:,k);
                save(FileName,'Data','Header')
                Header.FunctionType=30;
                Header.Unit=strcat('(',InHeader(1).Unit,')^2');
                Header=rmfield(Header,'RefDof');
                Header=rmfield(Header,'RefDir');
                FileName=strcat(OutPrefix,'F',int2str(OutStartNo));
                Data=Tff(:,k);
                save(FileName,'Data','Header')
                OutStartNo=OutStartNo+1;
            end
        else
            error('Wrong Proc type! Exiting.')
        end
    end
end
LastNumber=OutStartNo-1;        % Because OutStartNo is incremented last in loop
if fid > 1
    fclose(fid)
end
