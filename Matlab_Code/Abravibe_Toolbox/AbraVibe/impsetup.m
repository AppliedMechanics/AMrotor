function impsetup(DataFile,ChanNo,SetupFile)
%IMPSETUP Setup utility for IMPPROC
%
%       THIS FUNCTION IS OBSOLETE! Please check the new ImpactGui.m
%
%
%
%       impsetup(DataFile,ChanNo,SetupFile)
%
%       DataFile        Impact time file (MUST BE extension .imptime)
%       ChanNo          Response channel number in data file to be used for
%                        checks; MUST BE >= 2 (since force is first channel)
%       SetupFile       Filename of .impsetup file, WITHOUT extension!
%
% The results are stored in a setup file <FileName>.impsetup.
% This file is used by IMPPROC and the easiest way to produce the setup
% file is running IMPSETUP.
%
% This file prompts for user answer on command line!
%
% See also IMPPROC  

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Check that data file exist and load it
DataFile=strcat(DataFile,'.imptime');
if exist(DataFile,'file') == 2
    load(DataFile,'-mat');
    x=Data{1};
    y=Data{ChanNo};
    fs=1/Header(1).xIncrement;
else
    error('Data file does not exist!')
end

% Check if SetupFile already exists and if so load it. It contains a
% structure ImpSetup with (possibly) the following fields:
%   ImpSetup.TrigLevel      % Trigger level in % of max peak force
%           .PreTrigger     % Number of pretrigger samples
%           .N              % Blocksize (time samples in FFT)
%           .ForceWidthp    % Force window in percent of N
%           .ExpWinEnd      % Exponential window end factor in percent
InFileName=strcat(SetupFile,'.impsetup');
if exist(InFileName,'file') == 2
    load(InFileName,'-mat')
    fprintf('File found, opening with previous settings\n')
else
    % Define default setup structure
    % Check if positive or negative pulses in force signal
    if max(abs(Data{1}))/max(Data{1}) == 1
        ImpSetup.TrigLevel=5;
    else
        ImpSetup.TrigLevel=-5;
    end
    ImpSetup.PreTrigger=100;
    ImpSetup.N=2048;
    ImpSetup.ForceWidthp=100;
    ImpSetup.ExpWinEnd=100;
end

% Plot force/response and select which impacts to base setup phase on
fprintf('Current Settings:')
ImpSetup
fprintf('Select impacts to base setup phase on!\n')
[TrigIdx,DIdx]=imptrig2(x,y,fs,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger);

% Run through tests;

% First, set trigger and pretrigger:
LoopSwitch=1;
while LoopSwitch
    % Plot a window to zoom in and look
    h=impplot1(x,y,fs,ImpSetup.N,TrigIdx,DIdx,ImpSetup.TrigLevel);
    fprintf('Zoom in and examine force impacts if you wish. <RETURN> to continue...\n')
    pause
    close(h)
    a=input('Settings ok? (y/n)','s');
    a=upper(a);
    if strcmp(a,'Y')
        LoopSwitch=0;
    else
        ImpSetup.TrigLevel=input('Enter trigger level (%)');
        ImpSetup.PreTrigger=input('Enter new pretrigger (samples)')
        [TrigIdx,DIdx]=imptrig2(x,y,fs,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger);
        close(h);
        h=impplot1(x,y,fs,ImpSetup.N,TrigIdx,DIdx,ImpSetup.TrigLevel);
    end
end
close all

% TrigIdx

% Next find proper blocksize for no bias
% Use imptrig to find triggers to allow several executions
% of imp2frf2 with same triggers.
LoopSwitch=1;
while LoopSwitch
    fprintf('Current blocksize: %i\n',ImpSetup.N)
    NTest=input('Enter vector with blocksizes to compare within brackets, e.g. 1024*[1 2 4]')
    for n = 1:length(NTest)
        [H{n},f{n}] = imp2frf2(x,y,fs,NTest(n),TrigIdx,DIdx,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,0);
    end
    if isempty(H{n})
        fprintf('Too high blocksize for these data. Distance between impacts too short.')
        LoopSwitch=0;
    else
        h=figure;
        c={'b','g','r','m','c'};
        semilogy(f{1},abs(H{1}),c{1})
        LegendStruct{1}=int2str(NTest(1));
        hold on
        for n = 2:length(H)
            semilogy(f{n},abs(H{n}),c{n})
            LegendStruct{n}=int2str(NTest(n));
        end
%         legend(LegendStruct)
        title('You can zoom in on the FRFs by using the + zoom button')
    end
    a=input('Test other blocksizes? (y/n)','s');
    a=upper(a);
    if strcmp(a,'N')
        LoopSwitch=0;
        ImpSetup.N=input('Enter the blocksize you choose:');
    else
        LoopSwitch=1;
        if exist('h','var')
            close(h)
        end
    end
end
close all

%TrigIdx

% Next, optimize force window
LoopSwitch=1;
while LoopSwitch
    fprintf('Current Force window length:    %i\n',ImpSetup.ForceWidthp)
    % Plot first force impact zoomed in, and with overlaid force window
    h=figure;
    t=makexaxis(x,1/fs);
    idx=TrigIdx(1):TrigIdx(1)+ImpSetup.N-1;
    F=x(idx);
    w=aforcew(ImpSetup.N,ImpSetup.ForceWidthp);
    plot(t(idx),F.*w,t(idx),1.01*max(abs(x(TrigIdx(1):TrigIdx(1)+ImpSetup.N)))*w);
    title('Force window and windowed force signal, first impact')
    fprintf('Examine force signal and force window. <RETURN> to continue...\n')
    pause
    [H,f,C,Tff] = imp2frf2(x,y,fs,ImpSetup.N,TrigIdx,DIdx,ImpSetup.ForceWidthp,ImpSetup.ExpWinEnd,1);
    a=input('Change force window length? (y/n)','s');
    a=upper(a);
    if strcmp(a,'N')
        LoopSwitch=0;
    else
        ImpSetup.ForceWidthp=input('Enter force window length (%)');
    end
end
close all

%TrigIdx
% Finally optimize exponential window
LoopSwitch=1;
%[TrigIdx,DIdx]=imptrig2(x,y,fs,ImpSetup.N,ImpSetup.TrigLevel,ImpSetup.PreTrigger);
ExpPar=ImpSetup.ExpWinEnd
fprintf('Current exponential window end value: %f\n',ExpPar)
c={'b','g','r','m','c'};        % Color string for plotting
while LoopSwitch
    if length(ExpPar) == 1
        clear H f C
        [H,f,C] = imp2frf2(x,y,fs,ImpSetup.N,TrigIdx,DIdx,ImpSetup.ForceWidthp,ExpPar,0);
        figure
        plot(f,C,c{1})
    else
        clear H f C
        for n = 1:length(ExpPar)
            [H{n},f{n},C{n}] = imp2frf2(x,y,fs,ImpSetup.N,TrigIdx,DIdx,ImpSetup.ForceWidthp,ExpPar(n),0);
        end
        figure
        plot(f{1},C{1},c{1})
        LegendStruct{1}=num2str(ExpPar(1));
        hold on
        for n = 2:length(H)
            plot(f{n},C{n},c{n})
            LegendStruct{n}=num2str(ExpPar(n))
        end
%         legend(LegendStruct)
        title('You can zoom in on the FRFs by using the + zoom button')
    end
    a=input('Compare other exponential window end values? (y/n)','s');
    a=upper(a);
    if strcmp(a,'N')
        LoopSwitch=0;
        ImpSetup.ExpWinEnd=input('Enter exponential window end factor to use (in percent): ');
    else
        ExpPar=input('Enter exponential window end value(s) to compare in vector [] (%)')
    end
end

% Save ImpSetup struct in setup file
save(InFileName,'ImpSetup')
close all

fprintf('Saved settings:')
ImpSetup
