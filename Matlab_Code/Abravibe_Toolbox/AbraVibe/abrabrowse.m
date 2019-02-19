function varargout = abrabrowse(varargin)
% ABRABROWSE GUI-based data browser for ABRAVIBE toolbox data files
%
%      abrabrowse(StartDir)
%
%      StartDir         Cell array with string for directory to open
%                       If not passed, abrabrowse starts in the current directory
%
%      Starts a GUI with options to scroll through, and plot, data stored
%      in the ABRAVIBE file formats. Also, universal files with records of
%      type 58 (test data) can be imported.
%
%      Data are plotted using the command PLOTFILE. See inside the file
%      plotfile.m to see how to change default plot formats.

% Last Modified by GUIDE v2.5 12-May-2018 17:25:36

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-01-10  Made more robust if some files are not ABRAVIBE
%                          files. These are now ignored. Also made more
%                          robust for some fields that may not exist but
%                          can still be treated as valid files.
%          1.2 2014-07-10  Updated to allow .imptime files, and smaller
%                          improvements. Close All button no longer closes
%                          GUI
%          1.3 2014-07-20  Minor robustness fixed
%          1.4 2014-10-01  Fixed bug with imptime file headers
%          1.5 2014-11-21  Added waitbar while scanning files in new directory
%
% This file is part of ABRAVIBE Toolbox for NVA

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @abrabrowse_OpeningFcn, ...
    'gui_OutputFcn',  @abrabrowse_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before abrabrowse is made visible.
function abrabrowse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to abrabrowse (see VARARGIN)

% Choose default command line output for abrabrowse
handles.output = hObject;

if length(varargin) > 0
    handles.StartDir=varargin{1};
else
    handles.StartDir=pwd;
end

% Default values
handles.CurrSelection=[];
handles.TitleLine=1;
handles.Overlay=0;

% List all files in the current directory and fill list variable
List=update_list(handles);
set(handles.FileTable,'Data',List)
set(handles.DirString,'string',handles.StartDir)
handles.CurrentDirectory=pwd;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes abrabrowse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = abrabrowse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileTable=get(handles.FileTable,'Data');
for n = 1:length(handles.CurrSelection)
    FileList{n}=char(FileTable(handles.CurrSelection(n),1));
end
% Check if there are .imptime files in the FileList array
ImpTimeIdx=findstr(cell2mat(FileList),'.imptime');
AbravibeIdx=findstr(cell2mat(FileList),'.mat');
if handles.Overlay
    if ~isempty(ImpTimeIdx) & ~isempty(AbravibeIdx)
        errordlg('You cannot overlay plot a mix of imptime and ordinary files!')
    elseif ~isempty(AbravibeIdx)
        plotfile(FileList,handles.Overlay);
    elseif ~isempty(ImpTimeIdx)
        plotfile(FileList,handles.Overlay);
%         errordlg('You cannot overlay plot imptime files!')
    end
else
    if ~isempty(ImpTimeIdx) & ~isempty(AbravibeIdx)
        % Mix of .imptime and regular ABRAVIBE files. Split!
        NextImpIdx=1;
        NextAbraIdx=1;
        %         ImpList={};
        %         AbraList={};
        for n=1:length(FileList)
            if findstr(FileList{n},'.mat')
                AbraList{NextAbraIdx}=FileList{n};
                NextAbraIdx=NextAbraIdx+1;
            else
                ImpList{NextAbraIdx}=FileList{n};
                NextImpIdx=NextImpIdx+1;
            end
        end
    elseif ~isempty(ImpTimeIdx)
        ImpList=FileList;
    elseif ~isempty(AbravibeIdx)
        AbraList=FileList;
    end
    if ~isempty(ImpTimeIdx)
        plotfile(ImpList)
    end
    if ~isempty(AbravibeIdx)
        plotfile(AbraList)
    end
end


% --- Executes on button press in OverlayCheckbox.
function OverlayCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OverlayCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OverlayCheckbox
handles.Overlay=get(hObject,'Value');
guidata(hObject,handles)

% --- Executes on button press in ChangeDirButton.
function ChangeDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D=uigetdir;         
if isstr(D)    % 2014-07-20 Fixed action on Cancel button
    set(handles.DirString,'String',D);
    cd(D)
    List=update_list(handles);
    set(handles.FileTable,'Data',List)
    guidata(hObject,handles);
end

% --- Executes when selected cell(s) is changed in FileTable.
function FileTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to FileTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
selection = eventdata.Indices(:,1);
% Remove duplicate row IDs
selection = unique(selection);
% Cache the selection in case the plot type changes
handles.CurrSelection = selection;
guidata(hObject,handles)


% --- Executes on button press in ImportUnvButton.
function ImportUnvButton_Callback(hObject, eventdata, handles)
% hObject    handle to ImportUnvButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileList=uigetfile({'*.unv','Universal files (*.unv)';...
    '*.uff','Universal files (*.uff)'},...
    'Select one or more unv files',...
    'MultiSelect','on')
if isnumeric(FileList) & FileList == 0
elseif ischar(FileList)
    unvread(FileList,'ab',1);
elseif iscell(FileList)
    FirstFile=0;
    for n=1:length(FileList)
        FileName=FileList{n};
        FirstFile=unvread(FileName,'ab',FirstFile+1);
    end
end
List=update_list(handles);
set(handles.FileTable,'Data',List)
guidata(hObject,handles);


% --- Executes on button press in PlotReimButton.
function PlotReimButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotReimButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileTable=get(handles.FileTable,'Data');
for n = 1:length(handles.CurrSelection)
    FileName=char(FileTable(handles.CurrSelection(n),1));
    if isempty(findstr(FileName,'.imptime'));
        load(FileName)
        x=makexaxis(Data,Header.xIncrement);
        plotreim(x,Data)
        xlabel('Frequency [Hz]')
        title(strcat(functype(Header.FunctionType),{' '},Header.Label,{' '},Header.Unit))
    end
end


% --- Executes on selection change in TitleLinePopup.
function TitleLinePopup_Callback(hObject, eventdata, handles)
% hObject    handle to TitleLinePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TitleLinePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TitleLinePopup
handles.TitleLine=get(hObject,'Value');
% D=dir('*.mat');
List=update_list(handles);
set(handles.FileTable,'Data',List)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function TitleLinePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TitleLinePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CloseAllButton.
function CloseAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0, 'ShowHiddenHandles', 'on')
H=get(0, 'Children');
for n = 2:length(H)
    close(H(n))
end



function DirString_Callback(hObject, eventdata, handles)
% hObject    handle to DirString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DirString as text
%        str2double(get(hObject,'String')) returns contents of DirString as a double
% Do not allow edit; if edited, just set it back
set(hObject,'String',handles.CurrentDirectory);

% --- Executes during object creation, after setting all properties.
function DirString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DirString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%=======================================================================
% Customized function
function List = update_list(handles)

% First read all .mat files and add those that contain ABRAVIBE headers to
% the file list
%_______________________________________
D=dir('*.mat');
List=[];
NextLine=1;             % Lines in List
% Open waitbar, as it can take some time to scan a large number of files
h=waitbar(0,'Scanning for .mat files...','Name','Abrabrowse');
for n=1:length(D)
    waitbar(n/length(D),h);
    FileName=D(n).name;
    warning off
    load(FileName,'Header');
    warning on
    if ~exist('Header','var')
        Header='';
    end
    if abrahead(Header)             % Ignore if not an ABRAVIBE file!
        List{NextLine,1}=FileName;
        List{NextLine,2}=functype(Header.FunctionType);
        if Header.FunctionType == 4 | Header.FunctionType == 6
            if isfield(Header,'RefUnit')    % 2012-01-10 added flexibility if REfUnit field not included
                List{NextLine,3}=strcat(Header.Unit,'/',Header.RefUnit);
            else
                List{NextLine,3}=strcat(Header.Unit);
            end
        else
            List{NextLine,3}=Header.Unit;
        end
        List{NextLine,4}=char(headpstr(Header));
        List{NextLine,5}=int2str(Header.NoValues);
        if isfield(Header,'Date')           % 2012-01-10 added flexibility if Date field not included
            List{NextLine,6}=deblank(Header.Date);
        else
            List{NextLine,6}='';
        end
        if handles.TitleLine == 1
            List{NextLine,7}=Header.Title;
        elseif handles.TitleLine < 5
            if handles.TitleLine == 2
                if isfield(Header,'Title2')
                    List{NextLine,7}=Header.Title2;
                else
                    List{NextLine,7}='No title line 2';
                end
            elseif handles.TitleLine == 3
                if isfield(Header,'Title3')
                    List{NextLine,7}=Header.Title3;
                else
                    List{NextLine,7}='No title line 3';
                end
            elseif handles.TitleLine == 4
                if isfield(Header,'Title4')
                    List{NextLine,7}=Header.Title4;
                else
                    List{NextLine,7}='No title line 4';
                end
            end
        elseif handles.TitleLine == 5   % Orig. file name is selected
            if isfield(Header,'OrgFileName')
                List{NextLine,7}=Header.OrgFileName;
            else
                List{NextLine,7}='No original file name';
            end
        end
        NextLine=NextLine+1;
    end
end
% Next, list all .imptime files. These are simply assumed to be of ABRAVIBE
% format
D=dir('*.imptime');
for n=1:length(D)
    waitbar(n/length(D),h,'Scanning for .imptime files...');
    FileName=D(n).name;
    load(FileName,'-mat');
    List{NextLine,1}=FileName;
    List{NextLine,2}='Impact Time';
    List{NextLine,3}=strcat(Header(1).Unit,',',Header(2).Unit);
    if length(Data) == 2
        List{NextLine,4}=strcat('(',char(headpstr(Header(2))),')/',char(headpstr(Header(1))));
    else
        List{NextLine,4}=strcat('*/',char(headpstr(Header(1))));
    end
    % If old header type, convert
    if isfield(Header(1),'NumberSamples')
        fprintf('Found old header format.Converting!\n')
        for k=1:length(Data)
            Header(k).NoValues=Header(k).NumberSamples;
        end
        Header=rmfield(Header,'NumberSamples');
        save(FileName,'Data','Header')
    elseif ~isfield(Header(1),'NoValues')   % Some old files may miss this field
        for k=1:length(Data)
            Header(k).NoValues=length(Data{k});
        end
        save(FileName,'Data','Header')
    end
    List{NextLine,5}=int2str(Header(1).NoValues);
    if isfield(Header,'Date')   % To account for old format
        List{NextLine,6}=deblank(Header(1).Date);
    else
        List{NextLine,6}='No Date!';
    end
    if handles.TitleLine == 1
        List{NextLine,7}=Header(1).Title;
    elseif handles.TitleLine < 5
            if handles.TitleLine == 2
                if isfield(Header(1),'Title2')
                    List{NextLine,7}=Header(1).Title2;
                else
                    List{NextLine,7}='No title line 2';
                end
            elseif handles.TitleLine == 3
                if isfield(Header(1),'Title3')
                    List{NextLine,7}=Header(1).Title3;
                else
                    List{NextLine,7}='No title line 3';
                end
            elseif handles.TitleLine == 4
                if isfield(Header(1),'Title4')
                    List{NextLine,7}=Header(1).Title4;
                else
                    List{NextLine,7}='No title line 4';
                end
            end
    elseif handles.TitleLine == 5   % Orig. file name is selected
        if isfield(Header(1),'OrgFileName')
            List{NextLine,7}=Header(1).OrgFileName;
        else
            List{NextLine,7}='No original file name';
        end
    end
    NextLine=NextLine+1;
end
close(h)
List=sortrows(List);


% --- Executes on button press in PlotLogAmpButton.
function PlotLogAmpButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotLogAmpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileTable=get(handles.FileTable,'Data');
for n = 1:length(handles.CurrSelection)
    FileName=char(FileTable(handles.CurrSelection(n),1));
    if isempty(findstr(FileName,'.imptime'));
        load(FileName)
        if Header.FunctionType ~= 1
            x=makexaxis(Data,Header.xIncrement);
            figure;semilogy(x,Data)
            xlabel('Frequency [Hz]')
            ylabel(strcat(functype(Header.FunctionType),{' '},Header.Label,{' '},Header.Unit))
        end
    end
end
