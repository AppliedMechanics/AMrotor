function varargout = sdiagramGUI(varargin)
% SDIAGRAMGUI MATLAB code for sdiagramGUI.fig. This is an internal function
% called by sdiagramnew.m.
%
%      [p,N] = sdiagramGUI(fmif,MIF,NoPoles,nSign,Poles,fOffset)
%

% Copyright (c) 2018 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2018-03-12 First version of GUI
% This file is part of ABRAVIBE Toolbox for NVA

% Last Modified by GUIDE v2.5 11-Mar-2018 13:07:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sdiagramGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @sdiagramGUI_OutputFcn, ...
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


% --- Executes just before sdiagramGUI is made visible.
function sdiagramGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sdiagramGUI (see VARARGIN)

% Choose default command line output for sdiagramGUI
handles.output = hObject;

% Defaults
% Hardcode parameters
handles.fLim=0.001;             % pole is 'frequency stable' if relative diff less than fLim
handles.zLim=0.05;              % pole is stable if relative difference in damping less than zLim AND
% fLim is also fulfilled
handles.nSign='ro';             % Marker for new poles is red + sign
handles.fSign='bd';             % Marker for stable frequency is blue diamond
handles.sSign='g+';             % Marker for stable pole is green plus
handles.MarkerSize=4;           % Size of markers


% Parse inputs
handles.fmif=varargin{1};
handles.MIF=varargin{2};
handles.NoPoles=varargin{3};
handles.nSign=varargin{4};
handles.Poles=varargin{5};
handles.fOffset=varargin{6};

% Default values
handles.ContinueSelecting=true;

% Define help menu and items
h1 = uimenu('Label', 'Help');
     uimenu(h1,'Label','Help','Callback','StabDiaHelp');
     uimenu(h1,'Label','About','Callback','StabdiaGUIAbout');

%=========================================================================
% Start processing; fill the stabilization diagram with symbols
handles=FillPlot(hObject,handles);

% Wait for mouse clicking and act
axes(handles.StabPlot);
dcm_obj = datacursormode(gcf);
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','on','Enable','on')
while handles.ContinueSelecting
    k=waitforbuttonpress;
    if k == 0
        c_info = getCursorInfo(dcm_obj);
        % Make sure a pole was selected, and not a point on a MIF function.
        % This is done by checking that the array selected has Marker being
        % a +, o, or d 
        clear poles OrderIdx
        idx=1;          % Used for actual pole selections
        for n=1:length(c_info)
            % Only process poles, and not if one of the MIF functions
            % was accidentally marked
            if strcmp(c_info(n).Target.Marker,'+') | strcmp(c_info(n).Target.Marker,'o') | strcmp(c_info(n).Target.Marker,'d')
                %       % Find closest selected model order
                OrderIdx(idx)=find(c_info(n).Position(2) == handles.NoPoles);
                % Find the pole at that model order, by equal frequency
                [~,PoleIdx]=min(abs((c_info(n).Position(1)*2*pi - abs(handles.Poles{OrderIdx(idx)}))));
                poles(idx)=handles.Poles{OrderIdx(idx)}(PoleIdx);
                idx=idx+1;
            end
        end
        % Sort in ascending order
        %         listpoles(poles)
        if exist('poles')
            [~,I]=sort(abs(poles));
            poles=poles(I);
            %         listpoles(poles)
            OrderIdx=OrderIdx(I);
            % Fill frequency/damping table with the values found
            [fr,zr]=poles2fz(poles(:));
            A=[fr 100*zr];
            list=num2cell(A);
            set(handles.PoleTable,'data',list)
        end
    else
        handles.ContinueSelecting=false;
    end
end

% Define outputs
handles.SelectedPoles=poles(:);
for n=1:length(OrderIdx)
    handles.SelectedOrders{n}=handles.NoPoles(OrderIdx(n));
end


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes sdiagramGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sdiagramGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SelectedPoles;
varargout{2} = handles.SelectedOrders;



function MinXValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MinXValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinXValueEdit as text
%        str2double(get(hObject,'String')) returns contents of MinXValueEdit as a double
xmin=str2double(get(hObject,'String'));
A=xlim;
xlim([xmin A(2)]);

% --- Executes during object creation, after setting all properties.
function MinXValueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinXValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxXValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxXValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxXValueEdit as text
%        str2double(get(hObject,'String')) returns contents of MaxXValueEdit as a double
xmax=str2double(get(hObject,'String'));
A=xlim;
xlim([A(1) xmax]);


% --- Executes during object creation, after setting all properties.
function MaxXValueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxXValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function PoleTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PoleTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in LeftAutoButton.
function LeftAutoButton_Callback(hObject, eventdata, handles)
% hObject    handle to LeftAutoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Read current max limit. Restore left value to default
A=xlim;
xmax=A(2);
xlim([handles.DefaultMinXAxisValue xmax])
set(handles.MinXValueEdit,'String',num2str(handles.DefaultMinXAxisValue));
guidata(hObject,handles)

% --- Executes on button press in RightAutoButton.
function RightAutoButton_Callback(hObject, eventdata, handles)
% hObject    handle to RightAutoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A=xlim;
xmin=A(1);
xlim([xmin handles.DefaultMaxXAxisValue])
set(handles.MaxXValueEdit,'String',num2str(handles.DefaultMaxXAxisValue));
guidata(hObject,handles)


function handles = FillPlot(hObject,handles)
% Internal function that plots the stability diagram in the init of the
% main function
    % Read inputs from handles
    fmif=handles.fmif;
    MIF=handles.MIF;
    NoPoles=handles.NoPoles;
    nSign=handles.nSign;
    Poles=handles.Poles;
    fOffset=handles.fOffset;
    MarkerSize=handles.MarkerSize;
    % Plot stabilization diagram
    axes(handles.StabPlot);
    % Plot MIF function and hold plot for poles to be plotted
    handles.MIFHandle=plot(fmif,MIF*max(NoPoles));
%     set(gcf,'toolbar','figure')
    axis([min(fmif) max(fmif) 0 max(NoPoles)])
    xlabel('Frequency [Hz]')
    ylabel('Number of Poles')
    title('Stabilization Diagram, green=stable; blue=stable freq.; red=unstable')
    hold on
    
    % Check stability and plot symbols accordingly
    NPoles=NoPoles(1);
    LastRow=Poles{1};               % First row stored
    wp=abs(LastRow);                % Previous freqs
    zp=-real(LastRow)./abs(LastRow);
    handles.PolesHandle=plot(wp/2/pi+fOffset,NPoles,nSign,'MarkerSize',MarkerSize);
    for n = 2:length(NoPoles)                % Each row (model order) in diagram
        NPoles=NoPoles(n);
        for m = 1:length(Poles{n})   % Each pole m from order n
            wr=sqrt(abs(Poles{n}(m))^2);
            zr=-real(Poles{n}(m))/abs(Poles{n}(m));
            % See if the pole is within limits of a pole in last row
            fDist=abs(wr-wp)./abs(wp);
            zDist=abs(zr-zp)./abs(zp);
            if min(fDist) < handles.fLim & min(zDist) < handles.zLim    % Stable pole
                plot(wr/2/pi+fOffset,NPoles,handles.sSign,'MarkerSize',MarkerSize)
            elseif min(abs(wr-wp)/abs(wp)) < handles.fLim       % Stable frequency
                plot(wr/2/pi+fOffset,NPoles,handles.fSign,'MarkerSize',MarkerSize)
            else
                plot(wr/2/pi+fOffset,NPoles,handles.nSign,'MarkerSize',MarkerSize)       % New pole
            end
        end
        LastRow=Poles{n};               % First row stored
        wp=abs(LastRow);     % Previous freqs
        zp=-real(LastRow)./abs(LastRow);
    end
    A=xlim;
    handles.DefaultMinXAxisValue=A(1);
    handles.DefaultMaxXAxisValue=A(2);
    set(handles.MinXValueEdit,'String',num2str(handles.DefaultMinXAxisValue));
    set(handles.MaxXValueEdit,'String',num2str(handles.DefaultMaxXAxisValue));
    guidata(hObject, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% close(handles.figure1)
% sdiagramGUI_OutputFcn(hObject, eventdata, handles)
delete(hObject);
