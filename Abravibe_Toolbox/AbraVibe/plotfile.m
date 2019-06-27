function plotfile(FileList,Overlay,col);
% PLOTFILE  Plot data in ABRABIVE file(s) with default format
%
%           plotfile(FileList,Overlay,col);
%
%           FileList    String or, if more than one file, cell array with
%                       file name(s). All files must exist. The list can
%                       contain EITHER regular ABRAVIBE files (with
%                       extension .mat), OR .imptime files
%           Overlay     Logical, if = 1, all files containing the same
%                       measurement function will be plotted in the same window
%           col         Color string, or cell array of strings, see PLOT
%                       Must be same length as FileList
%
%


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2011-10-14 Added support for type 12, and for x axes not
%                         starting at 0
%          1.2 2013-11-16 Added support for type 30, transient spectrum
%          1.3 2014-07-10 Added support for .imptime files. Limitation is
%                         that entire FileList must contain *either* .imptime 
%                         *or* regular ABRAVIBE files
%          1.4 2014-11-05 Added fixed ylim [0 1] for coherence
%          1.5 2018-05-10 Added support for type 26, multiple coherence and
%                         fixed bug for overlay plot of imptime files
%
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin == 1
    Overlay = 0;
    col='DEF';
elseif nargin == 2
    col='DEF';
else
    col=upper(col);
end

% Defaults are also defined in subfunction PlotFunction at the end of this
% file!
DefCol=[ 0         0    1.0000
         0    0.5000         0
    1.0000         0         0
         0    0.7500    0.7500
    0.7500         0    0.7500
    0.7500    0.7500         0
    0.2500    0.2500    0.2500];

% Detect which sort of file extension are in the list
Idx=findstr(cell2mat(FileList),'.imptime');
if ~isempty(Idx)
    FileTypes = 'IMPTIME';
else
    FileTypes = 'MAT';
end    

% Process, depending of file types
if strcmp(FileTypes,'MAT')
    if Overlay & iscell(FileList) & length(FileList) > 1
        % Go through all files and find function type
        FunctionType=zeros(1,length(FileList));
        for fileno = 1:length(FileList)
            if iscell(FileList) & length(FileList) > 1
                FileName=FileList{fileno};
            else
                FileName=FileList;
            end
            load(FileName,'Header');
            FunctionType(fileno)=Header.FunctionType;
        end
        % Sort function type and rearrange FileList accordingly
        [FunctionType,idx]=sort(FunctionType);
        for n=1:length(idx)
            NewFileList{n}=FileList{idx(n)};
        end
        FileList=NewFileList;
        % Find out where the function type changes
        NoFunctionTypes=length(unique(FunctionType));
        StartFunctionIdx(1)=1;
        idx=1;
        for n = 2:length(FunctionType)
            if FunctionType(n) ~= FunctionType(n-1)
                idx=idx+1;
                StartFunctionIdx(idx)=n;
            end
        end
        StartFunctionIdx(idx+1)=length(FileList)+1; % To stop loop later
    elseif Overlay & iscell(FileList)     % Overlay is selected but only one file selected
        Overlay = false;
    end
    
    % Loop through all files
    if ~Overlay
        if iscell(FileList)
            for fileno = 1:length(FileList)
                FileName=FileList{fileno};
                load(FileName);
                x=makexaxis(Data,Header.xIncrement,Header.xStart);
                PlotFunction(x,Data,Header);
            end
        else
            load(FileList)
            x=makexaxis(Data,Header.xIncrement,Header.xStart);
            PlotFunction(x,Data,Header);
        end
    else
        % Loop through each function type and plot
        for FuncTypeNumber = 1:length(StartFunctionIdx)-1
            col=1; clear y
            for fileno = StartFunctionIdx(FuncTypeNumber):StartFunctionIdx(FuncTypeNumber+1)-1
                FileName=FileList{fileno};
                load(FileName)
                y(:,col)=Data;
                col=col+1;
            end
            x=makexaxis(Data,Header.xIncrement,Header.xStart);
            PlotFunction(x,y,Header);
        end
    end
else % IMPTIME files
    for n = 1:length(FileList)
        FileName=FileList{n};
        load(FileName,'-mat')
        PlotImptime(Data,Header,Overlay)
    end
end
        


function PlotFunction(x,y,Header,c)

% Default plot parameters
LineWidth=1;
FontSize=9;
FontName='Times New Roman';
GridString='grid on';

type=Header.FunctionType;
if type == 0
    figure
    plot(x,y,'LineWidth',LineWidth)
    xlabel('Unknown','FontName',FontName,'FontSize',FontSize);
    ylabel('Unknown','FontName',FontName,'FontSize',FontSize);
    eval(GridString);
elseif type == 1        % Time
    figure
    plot(x,y,'LineWidth',LineWidth);
    xlabel('Time [s]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header,'Unit')
        UnitString=Header.Unit;
    else
        UnitString='';
    end
    if isfield(Header,'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat(Label,'{ [}',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
elseif type == 4        % FRF
    figure
    subplot(2,1,1)
    semilogy(x,abs(y),'LineWidth',LineWidth);
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header,'Unit')
        UnitString=Header.Unit;
    else
        UnitString='';
    end
    if isfield(Header,'RefUnit')
        RefUnit=Header.RefUnit;
    else
        RefUnit='';
    end
    if isfield(Header,'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat('{FRF }',Label,'{ [(}',UnitString,')/',RefUnit,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    TString=headpstr(Header);
    title(TString);
    eval(GridString);
    subplot(2,1,2)
    plot(x,angledeg(y));
    ylabel('Phase [Deg.]','FontName',FontName,'FontSize',FontSize);
    eval(GridString);
elseif type == 6        % Coherence
    figure
    plot(x,y,'LineWidth',LineWidth);
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    ylabel('Coherence','FontName',FontName,'FontSize',FontSize);
    ylim([0 1])
    TString=headpstr(Header);
    title(TString);
    eval(GridString);
elseif type == 7        % Autocorrelation
    figure
    plot(x,y,'LineWidth',LineWidth);
    xlabel('Time Lag [s]','FontName',FontName,'FontSize',FontSize);
    ylabel('Autocorrelation','FontName',FontName,'FontSize',FontSize);
    TString=headpstr(Header);
    title(TString);
    eval(GridString);
elseif type == 8        % Cross-correlation
    figure
    plot(x,y,'LineWidth',LineWidth);
    xlabel('Time Lag [s]','FontName',FontName,'FontSize',FontSize);
    ylabel('Cross-correlation','FontName',FontName,'FontSize',FontSize);
    TString=headpstr(Header);
    title(TString);
    eval(GridString);
elseif type == 9        % PSD or CSD 
    figure
    semilogy(x,abs(y),'LineWidth',LineWidth); % 2014-03-03: Fixed with abs(y) to work for CSD
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header,'Unit')
        UnitString=Header.Unit;
    else
        UnitString='';
    end
    if isfield(Header,'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat('{PSD }',Label,'{ [}',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
elseif type == 12        % Spectrum. This type can be either linear (RMS) 
                         % spectrum or phase spectrum, so abs(Data) is plotted
    figure
    plot(x,abs(y),'LineWidth',LineWidth);
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header,'Unit')
        UnitString=Header.Unit;
    else
        UnitString='';
    end
    if isfield(Header,'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat('Spectrum ',Label,'{ [}',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
elseif type == 26        % Multiple Coherence
    figure
    plot(x,y,'LineWidth',LineWidth);
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    ylabel('Mult. Coherence','FontName',FontName,'FontSize',FontSize);
    ylim([0 1])
    TString=headpstr(Header);
    title(TString);
    eval(GridString);
elseif type == 30        % Transient Spectrum. 
    figure
    semilogy(x,(y),'LineWidth',LineWidth);
    xlabel('Frequency [Hz]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header,'Unit')
        UnitString=Header.Unit;
    else
        UnitString='';
    end
    if isfield(Header,'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat('{Trans. Spec. }',Label,'{ [}',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
end


function PlotImptime(Data,Header,Overlay)
% Default plot parameters
LineWidth=1;
FontSize=9;
FontName='Times New Roman';
GridString='grid on';

if Overlay
    t=makexaxis(Data{1},Header(1).xIncrement);
    figure
    subplot(2,1,1)
    plot(t,Data{1},'LineWidth',LineWidth)
    xlabel('Time [s]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header(1),'Unit')
        UnitString=Header(1).Unit;
    else
        UnitString='';
    end
    if isfield(Header(1),'Label')
        Label=Header.Label;
    else
        Label='';
    end
    YString=strcat(Label,' [',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
    subplot(2,1,2)
    plot(t,cell2mat(Data(2:end)),'LineWidth',LineWidth)
    xlabel('Time [s]','FontName',FontName,'FontSize',FontSize);
    if isfield(Header(2),'Unit')
        UnitString=Header(2).Unit;
    else
        UnitString='';
    end
    if isfield(Header(2),'Label')
        Label=Header(2).Label;
    else
        Label='';
    end
    YString=strcat(Label,' [',UnitString,']');
    ylabel(YString,'FontName',FontName,'FontSize',FontSize);
    eval(GridString);
else
    t=makexaxis(Data{1},Header(1).xIncrement);
    for n=1:length(Data)
        figure
        plot(t,Data{n},'LineWidth',LineWidth)
        xlabel('Time [s]','FontName',FontName,'FontSize',FontSize);
        if isfield(Header(n),'Unit')
            UnitString=Header(n).Unit;
        else
            UnitString='';
        end
        if isfield(Header(n),'Label')
            Label=Header(n).Label;
        else
            Label='';
        end
        YString=strcat(Label,' [',UnitString,']');
        ylabel(YString,'FontName',FontName,'FontSize',FontSize);
        eval(GridString);
    end
end