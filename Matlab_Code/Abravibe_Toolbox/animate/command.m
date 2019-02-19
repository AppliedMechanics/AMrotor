function varargout = command(action,varargin)

global SETUP MODAL GEOMETRY UDATA RESIZE UFF

aniFig  = findobj(0,'Tag','ANIMATE');
aniAxis = findobj(aniFig,'Tag','Axes:Single');

switch action
    case 'MaxDeflection'
        SETUP.Display.MaxDeflection=1;
    otherwise
        SETUP.Display.MaxDeflection=0;
end

switch action
    case 'initDefaults'
        varargout{1}	= getDefaults(SETUP);
    case 'run_animate'
        while get(findobj(aniFig,'Tag','Toggle:Animate'),'Value')
            animate_fcn;
            if ~ishandle(aniFig)
                return
            end
        end
    case 'components'
        dlg = findobj(0,'Tag','ANIMATE:COMPONENTS');
        if all([isempty(dlg),~strcmp(varargin{1},'init')])
            return
        end
        switch varargin{1}
            case 'init'
                if ishandle(dlg)
                    figure(dlg)
                    return;
                end
                if strcmp(SETUP.View.Type,'Red/Blue Glasses')
                    command('viewType','Single');
                end
                set(findobj(aniFig,'Tag','Menu:View:RedBlue'),'Enable','off');
                if length(varargin)<2
                    dlg     = guiComponents(aniFig,SETUP);
                else
                    dlg     = guiComponents(aniFig,SETUP,varargin{end});
                end
                % INIT GUI
                lbstr   = compListbox(SETUP);
                str = {'off','on'};
                set(findobj(dlg,'Tag','Component:Listbox')  ,'String',lbstr,'Value',1);
                set(findobj(dlg,'Tag','Component:Name')     ,'String',SETUP.Component.Name{1});
                set(findobj(dlg,'Tag','Component:Visible')  ,'Value' ,SETUP.Component.Visible(1));
                set(findobj(dlg,'Tag','Component:Fill')     ,'Value' ,SETUP.Component.Fill(1));
                set(findobj(dlg,'Tag','Component:Wireframe'),'Value' ,SETUP.Component.Wireframe);
                set(UDATA.Handles.Conn,'Visible',str{SETUP.Component.Wireframe+1});
                if SETUP.Component.Wireframe & SETUP.Display.Markers
                    set(UDATA.Handles.Markers,'Visible','on')
                else
                    set(UDATA.Handles.Markers,'Visible','off')
                end
                SETUP.Component.Open    = 1;
                command(action,'visible',find(SETUP.Component.Visible),1);
                command(action,'fill'   ,find(SETUP.Component.Fill),1);
                DATA    = get(aniAxis,'UserData');
                for comp=1:size(SETUP.Component.Name,1)
                    set(UDATA.Handles.Wire(comp,:),'XData',DATA.CompNodes(SETUP.Component.WireIndex{comp},1,UDATA.ActiveFrame),...
                        'YData',DATA.CompNodes(SETUP.Component.WireIndex{comp},2,UDATA.ActiveFrame),...
                        'ZData',DATA.CompNodes(SETUP.Component.WireIndex{comp},3,UDATA.ActiveFrame));
                    ind     = find(SETUP.Component.FillComps==comp);
                    for ii=1:length(ind)
                        set(UDATA.Handles.Fill(ind(ii),:),'XData',DATA.NODES(SETUP.Component.FillConn{ind(ii)},1,UDATA.ActiveFrame),...
                            'YData',DATA.NODES(SETUP.Component.FillConn{ind(ii)},2,UDATA.ActiveFrame),...
                            'ZData',DATA.NODES(SETUP.Component.FillConn{ind(ii)},3,UDATA.ActiveFrame));
                    end
                end
            case 'select'
                val = min(get(gcbo,'Value'));
                set(findobj(dlg,'Tag','Component:Name')     ,'String',SETUP.Component.Name{val});
                set(findobj(dlg,'Tag','Component:Visible')  ,'Value' ,SETUP.Component.Visible(val));
                set(findobj(dlg,'Tag','Component:Fill')     ,'Value' ,SETUP.Component.Fill(val));
            case 'name'
                str     = get(gcbo,'String');
                val     = get(findobj(dlg,'Tag','Component:Listbox'),'Value');
                if length(str)>10
                    str = str(1:10);
                end
                for ii=1:length(val)
                    SETUP.Component.Name{val(ii),1}  = str;
                end
                lbstr   = compListbox(SETUP);
                set(findobj(dlg,'Tag','Component:Listbox')  ,'String',lbstr);
                set(findobj(dlg,'Tag','Component:Name')     ,'String',SETUP.Component.Name{min(val)});
            case 'fill'
                str = {'off','on'};
                if nargin==2
                    val  = get(findobj(dlg,'Tag','Component:Listbox'),'Value');
                    onoff   = get(gcbo,'Value');
                    SETUP.Component.Fill(val,1)  = onoff;
                    lbstr   = compListbox(SETUP);
                    set(findobj(dlg,'Tag','Component:Listbox')  ,'String',lbstr);
                else
                    val     = varargin{2};
                    onoff   = varargin{3};
                end
                for ii=1:length(val)
                    ind = find(SETUP.Component.FillComps==val(ii));
                    set(UDATA.Handles.Fill(ind,:),'Visible',str{onoff+1});
                end
            case 'visible'
                if nargin==2
                    val  = get(findobj(dlg,'Tag','Component:Listbox'),'Value');
                    val     = get(findobj(dlg,'Tag','Component:Listbox'),'Value');
                    onoff   = get(gcbo,'Value');
                    SETUP.Component.Visible(val,:)  = onoff;
                    lbstr   = compListbox(SETUP);
                    set(findobj(dlg,'Tag','Component:Listbox')  ,'String',lbstr);
                else
                    val     = varargin{2};
                    onoff   = varargin{3};
                end
                str = {'off','on'};
                set(UDATA.Handles.Wire(val,:),'Visible',str{onoff+1});
                % enable labels
                if SETUP.Display.Labels & ~SETUP.Component.Wireframe
                    offInd  = find(~SETUP.Component.Visible);
                    onInd   = find( SETUP.Component.Visible);
                    indOff  = unique(setdiff([SETUP.Component.WireIndex{offInd}],length(UDATA.Handles.Labels)+1));
                    indOn   = unique(setdiff([SETUP.Component.WireIndex{onInd}] ,length(UDATA.Handles.Labels)+1));
                    set(UDATA.Handles.Labels(indOff,:),'Visible','off');
                    set(UDATA.Handles.Labels(indOn,:) ,'Visible','on');
                end
                %keyboard
                ostr    = str{all([SETUP.Display.Markers,SETUP.Component.Open])+1};
                set(UDATA.Handles.Mark(find(~SETUP.Component.Visible),:),'Visible','off');
                set(UDATA.Handles.Mark(find( SETUP.Component.Visible),:),'Visible',ostr);
            case 'fillColor'
                val     = get(findobj(dlg,'Tag','Component:Listbox'),'Value');
                clr     = getColor(SETUP.Component.Color(min(val),:),[SETUP.Component.Name{min(val)} ' fill color']);
                if isempty(clr)
                    return;
                end
                SETUP.Component.Color(val,:)    = ones(length(val),1)*clr;
                lbstr   = compListbox(SETUP);
                set(findobj(dlg,'Tag','Component:Listbox')  ,'String',lbstr);
                for comp=1:length(val)
                    set(UDATA.Handles.Wire(val(comp),:),'Color',clr);
                    set(UDATA.Handles.Mark(val(comp),:),'Color',clr);
                    for ii=1:length(val)
                        ind = find(SETUP.Component.FillComps==val(ii));
                        set(UDATA.Handles.Fill(ind,:),'FaceColor',clr);
                    end
                end
            case 'wireframe'
                str = {'off','on'};
                SETUP.Component.Wireframe = get(gcbo,'Value');
                set(UDATA.Handles.Conn,'Visible',str{SETUP.Component.Wireframe+1});
                if SETUP.Component.Wireframe & SETUP.Display.Labels
                    set(UDATA.Handles.Labels,'Visible','on');
                elseif SETUP.Display.Labels & ~SETUP.Component.Wireframe
                    offInd  = find(~SETUP.Component.Visible);
                    onInd   = find( SETUP.Component.Visible);
                    indOff  = unique(setdiff([SETUP.Component.WireIndex{offInd}],length(UDATA.Handles.Labels)+1));
                    indOn   = unique(setdiff([SETUP.Component.WireIndex{onInd}] ,length(UDATA.Handles.Labels)+1));
                    set(UDATA.Handles.Labels(indOff,:),'Visible','off');
                    set(UDATA.Handles.Labels(indOn,:) ,'Visible','on');
                end
                if SETUP.Component.Wireframe & SETUP.Display.Markers
                    set(UDATA.Handles.Markers,'Visible','on')
                else
                    set(UDATA.Handles.Markers,'Visible','off')
                end
            case 'stack'
                if ~strcmp(get(dlg,'SelectionType'),'open')
                    return
                end
                scrSize     = get(0         , 'ScreenSize');
                aniFigPos   = get(aniFig    , 'Position');
                dlgFigPos   = get(dlg       , 'Position');
                if aniFigPos(1)-dlgFigPos(3)-7>scrSize(1)
                    Xpos  = aniFigPos(1)-dlgFigPos(3)-7;
                elseif aniFigPos(1)+aniFigPos(3)+7+dlgFigPos(3)<scrSize(3);
                    Xpos  = aniFigPos(1)+aniFigPos(3)+7;
                else
                    Xpos  = aniFigPos(1)+aniFigPos(3)-dlgFigPos(3);
                end
                if aniFigPos(2)<scrSize(2)
                    Ypos  = aniFigPos(2)+aniFigPos(4)+10-dlgFigPos(4);
                elseif scrSize(4)-aniFigPos(4)<80
                    Ypos  = aniFigPos(2)+aniFigPos(4)-dlgFigPos(4)-75;
                else
                    Ypos  = aniFigPos(2)+aniFigPos(4)-dlgFigPos(4)+22;
                end
                set(dlg,'Position',[Xpos Ypos dlgFigPos(3) dlgFigPos(4)]);
        end
    case 'help'
        switch varargin{1}
            case 'help'
                if ~exist(fullfile(SETUP.Path.Root,'Help\animation.html'),'file')
                    [file,path] = uigetfile(fullfile(SETUP.Path.Root,'animation.html'),'Selected animation.html file...');
                    if file==0
                        return
                    end
                    SETUP.Path.Help = path;
                    defaults('addPaths',SETUP);
                end
                open(fullfile(SETUP.Path.Help,'\animation.html'));
            case 'about'
                guiAbout(aniFig,SETUP);
        end
    case 'updatePrefs'
        updatePrefs('all' ,findobj(0,'Tag','ANIMATE:PREFERENCES'),SETUP);
        set(findobj(0,'Tag','ANIMATE:PREFERENCES'),'Userdata',SETUP);
        
    case 'autoApplyPrefs'
        TEMP    = get(findobj(0,'Tag','ANIMATE:PREFERENCES'),'Userdata');
        updateAniFig(aniFig,TEMP,UDATA.Handles);
        SETUP.Animation = TEMP.Animation;
        SETUP.Display   = TEMP.Display;
        SETUP.View      = TEMP.View;
        SETUP.Colors    = TEMP.Colors;
        SETUP.AVI       = TEMP.AVI;
        SETUP.Snapshot  = TEMP.Snapshot;
        updatePrefs('all' ,findobj(0,'Tag','ANIMATE:PREFERENCES'),SETUP);
        set(findobj(0,'Tag','ANIMATE:PREFERENCES'),'Userdata',TEMP);
        command('reset_animation');
    case 'updateRotate'
        if strcmp(SETUP.View.Type,'Red/Blue Glasses')
            [AZ,EL] = view(aniAxis);
            ortho11 = findobj(aniFig,'Tag','Axes:Ortho11');
            set(ortho11,'View',[AZ,EL],'CameraUpVector',get(aniAxis,'CameraUpVector'));
            camorbit(ortho11, SETUP.View.CrosseyeAngle*2,0,'camera',SETUP.View.UpVector(2))
        end
        
    case 'preferences'
        dlg = findobj(0,'Tag','ANIMATE:PREFERENCES');
        if all([isempty(dlg),~strcmp(varargin{1},'init')])
            return
        end
        TEMP    = get(dlg,'Userdata');
        switch varargin{1}
            case 'autoapply'
                SETUP.Animation.AutoApplyPrefs  = get(gcbo,'Value');
                TEMP.Animation.AutoApplyPrefs   = get(gcbo,'Value');
            case 'update'
                updatePrefs('all' ,dlg,SETUP);
                set(dlg,'Userdata',SETUP);
            case 'init'
                if ishandle(dlg)
                    figure(dlg)
                    return;
                end
                prefFig = guiPreferences(aniFig,SETUP);
                set(prefFig,'Userdata',SETUP);
                verargout{1}    = prefFig;
                TEMP            = SETUP;
            case 'avi'
                switch varargin{2}
                    case 'Format'
                        str = get(gcbo,'String');
                        val = get(gcbo,'Value');
                        TEMP.AVI.Format = str{val};
                    case 'Quality'
                        val = abs(str2num(get(gcbo,'String')));
                        TEMP.AVI.Quality    = round(min([100,max([1,val])]));
                        set(gcbo,'String',num2str(TEMP.AVI.Quality));
                    case 'TimeLength'
                        TEMP.AVI.Quality    = abs(str2num(get(gcbo,'String')));
                        set(gcbo,'String',num2str(TEMP.AVI.TimeLength));
                    case 'DoAllModes'
                        TEMP.AVI.DoAllModes = get(gcbo,'Value');
                end
            case 'snapshot'
                switch varargin{2}
                    case 'Format'
                        str = get(gcbo,'String');
                        val = get(gcbo,'Value');
                        TEMP.Snapshot.Format    = str{val};
                    case 'Renderer'
                        str = get(gcbo,'String');
                        val = get(gcbo,'Value');
                        TEMP.Snapshot.Renderer  = str{val};
                    case 'Quality'
                        val = abs(str2num(get(gcbo,'String')));
                        TEMP.Snapshot.Quality   = round(min([100,max([1,val])]));
                        set(gcbo,'String',num2str(TEMP.Snapshot.Quality));
                    case 'Resolution'
                        TEMP.Snapshot.Resolution    = round(abs(str2num(get(gcbo,'String'))));
                        set(gcbo,'String',num2str(TEMP.Snapshot.Resolution));
                    case 'DoAllModes'
                        TEMP.Snapshot.DoAllModes    = get(gcbo,'Value');
                end
                
            case 'exportPath'
                switch varargin{2}
                    case 'edit'
                        dirStr  = get(gcbo,'String');
                        if exist(dirStr,'dir')~=7
                            resp = questdlg('%s\n\nDirectory does not exist.\nCreate it now?','Animation Warning','Yes','No','Yes');
                            if strcmp(resp,'No')
                                set(gcbo,'String',SETUP.Path.Export)
                                return;
                            else
                                mkdir(dirStr)
                            end
                        end
                        SETUP.Path.Export   = dirStr;
                    case 'push'
                        dirStr  = uigetdir(SETUP.Path.Export,'Choose the export directory...');
                        if dirStr == 0
                            return;
                        end
                        if exist(dirStr,'dir')~=7
                            resp = questdlg('%s\n\nDirectory does not exist.\nCreate it now?','Animation Warning','Yes','No','Yes');
                            if strcmp(resp,'No')
                                set(gcbo,'String',SETUP.Path.Export)
                                return;
                            else
                                mkdir(dirStr)
                            end
                        end
                        SETUP.Path.Export   = dirStr;
                        set(findobj(dlg,'Tag','Preferences:EditExportPath'),'String',SETUP.Path.Export)
                end
            case 'stack'
                if ~strcmp(get(dlg,'SelectionType'),'open')
                    return
                end
                scrSize     = get(0         , 'ScreenSize');
                aniFigPos   = get(aniFig    , 'Position');
                dlgFigPos   = get(dlg       , 'Position');
                if aniFigPos(1)-dlgFigPos(3)-7>scrSize(1)
                    Xpos  = aniFigPos(1)-dlgFigPos(3)-7;
                elseif aniFigPos(1)+aniFigPos(3)+7+dlgFigPos(3)<scrSize(3);
                    Xpos  = aniFigPos(1)+aniFigPos(3)+7;
                else
                    Xpos  = aniFigPos(1)+aniFigPos(3)-dlgFigPos(3);
                end
                if aniFigPos(2)<scrSize(2)
                    Ypos  = aniFigPos(2)+aniFigPos(4)+10-dlgFigPos(4);
                elseif scrSize(4)-aniFigPos(4)<80
                    Ypos  = aniFigPos(2)+aniFigPos(4)-dlgFigPos(4)-75;
                else
                    Ypos  = aniFigPos(2)+aniFigPos(4)-dlgFigPos(4)+22;
                end
                set(dlg,'Position',[Xpos Ypos dlgFigPos(3) dlgFigPos(4)]);
            case 'animation'
                val = str2num(get(gcbo,'String'));
                if isempty(val)
                    updatePrefs('animation',dlg,TEMP);
                    return;
                end
                switch varargin{2}
                    case 'FPC'
                        val = min([max([3,round(val)]),503]);
                        TEMP.Animation.Frames   = val;
                    case 'Amp'
                        val = min([max([0.01,round(val*100)/100]),100.01]);
                        TEMP.Animation.Amplitude = val;
                        
                    case 'Deg'
                        val = min([max([-360,round(val)]),360]);
                        TEMP.Animation.Theta   = val;
                end
            case 'display'
                eval(['TEMP.Display.' varargin{2} '=~TEMP.Display.' varargin{2} ';']);
            case 'view'
                str = get(gcbo,'String');
                val = get(gcbo,'Value');
                eval(['TEMP.View.' varargin{2} '=str{val};']);
            case 'apply'
                updateAniFig(aniFig,TEMP,UDATA.Handles);
                SETUP.Animation = TEMP.Animation;
                SETUP.Display   = TEMP.Display;
                SETUP.View      = TEMP.View;
                SETUP.Colors    = TEMP.Colors;
                SETUP.AVI       = TEMP.AVI;
                SETUP.Snapshot  = TEMP.Snapshot;
                TEMP            = SETUP;
                updatePrefs('all',dlg,TEMP);
                command('reset_animation');
            case 'reset'
                TEMP    = getDefaults(TEMP);
                SETUP.Animation.AutoApplyPrefs  = TEMP.Animation.AutoApplyPrefs;
                updatePrefs('all' ,dlg,TEMP);
            case 'defaults'
                TEMP    = defaults('loadDefaults',SETUP);
                SETUP.Animation.AutoApplyPrefs  = TEMP.Animation.AutoApplyPrefs;
                updatePrefs('all' ,dlg,TEMP);
            case 'save'
                defaults('writeINI',TEMP);
            case 'color'
                clr = getColor(eval(['TEMP.Colors.' varargin{2}]),[varargin{2} ' Color']);
                if isempty(clr);return;end
                eval(['TEMP.Colors.' varargin{2} '=clr;']);
        end % END Preferences =============================================
        set(dlg,'Userdata',TEMP)
        updatePrefs(varargin{1},dlg,TEMP);
        if SETUP.Animation.AutoApplyPrefs
            command('autoApplyPrefs');
        end

    case 'viewType'
        if strcmp(SETUP.View.Type,varargin{1})
            return;
        end
        SETUP.View.Type = varargin{1};
        ortho11 = findobj(aniFig,'Tag','Axes:Ortho11');
        ortho21 = findobj(aniFig,'Tag','Axes:Ortho21');
        ortho22 = findobj(aniFig,'Tag','Axes:Ortho22');
        delete([ortho11,ortho21,ortho22]);
        POS     = get(aniFig,'Position');
        set(aniAxis,'Position',[20 20 POS(3)-40 POS(4)-135]);
        set(UDATA.Handles.Markers(1)    ,'Color',SETUP.Colors.Markers)
        set(UDATA.Handles.Labels(:,1)   ,'Color',SETUP.Colors.Labels)
        set(UDATA.Handles.Conn(1)       ,'Color',SETUP.Colors.Shape)
        set(UDATA.Handles.Static(1)     ,'Color',SETUP.Colors.Static)
        set(UDATA.Handles.UCS(1,:)      ,'Color',SETUP.Colors.UCS)
        switch varargin{1}
            case 'Single'
                val =[1 0 0 0];
                set(findobj(aniFig,'Tag','Menu:View:Single'),'checked','on');
                set(findobj(aniFig,'Tag','Menu:View:Quad')  ,'checked','off');
                HAND    = getHandles(1,aniAxis,UDATA.Handles,'empty');
            
            case 'Quad'
                val =[0 1 0 0];
                ortho11 = copyobj(aniAxis,aniFig);
                pos     = get(ortho11,'Position');
                set(ortho11,'Position',[pos(1) pos(2)+pos(4)/2 pos(3)/2 pos(4)/2],'Tag','Axes:Ortho11');
                set(findobj(ortho11,'Tag','Axis:Shape'),'Erasemode','normal')
                [VWS,CUV]   = viewSetup(1,1,SETUP.View.UpVector);
                set(ortho11,'View',VWS,'CameraUpVector',CUV)
                HAND    = getHandles(2,ortho11,[]);

                ortho21 = copyobj(aniAxis,aniFig);
                set(ortho21 ,'Position',[pos(1) pos(2) pos(3)/2 pos(4)/2],'Tag','Axes:Ortho21');
                set(findobj(ortho21,'Tag','Axis:Shape'),'Erasemode','normal')
                [VWS,CUV] = viewSetup(2,3,SETUP.View.UpVector);
                set(ortho21,'View',VWS,'CameraUpVector',CUV)
                HAND    = getHandles(3,ortho21,HAND);

                ortho22 = copyobj(aniAxis,aniFig);
                set(ortho22 ,'Position',[40+pos(1)+pos(3)/2 pos(2) pos(3)/2 pos(4)/2],'Tag','Axes:Ortho22');
                set(findobj(ortho22,'Tag','Axis:Shape'),'Erasemode','normal')
                [VWS,CUV] = viewSetup(3,4,SETUP.View.UpVector);
                set(ortho22,'View',VWS,'CameraUpVector',CUV)
                HAND    = getHandles(4,ortho22,HAND);

                set(aniAxis     ,'Position',[40+pos(1)+pos(3)/2 pos(2)+pos(4)/2 pos(3)/2 pos(4)/2]);
                set(findobj(aniAxis,'Tag','Axis:Shape'),'Erasemode','normal')
                [VWS,CUV] = viewSetup(1,2,SETUP.View.UpVector);
                set(aniAxis,'View',[135 35],'CameraUpVector',CUV)
                set(findobj(aniFig,'Tag','Menu:View:Single'),'checked','off');
                set(findobj(aniFig,'Tag','Menu:View:Quad')  ,'checked','on');
                HAND    = getHandles(1,aniAxis,HAND);

                delete(findobj(ortho11,'Tag','ContextMenu\Axes'))
                delete(findobj(ortho21,'Tag','ContextMenu\Axes'))
                delete(findobj(ortho22,'Tag','ContextMenu\Axes'))
            case 'Cross-eyed'
                val =[0 0 1 0];
                ortho11 = copyobj(aniAxis,aniFig);
                pos     = get(ortho11,'Position');
                set(ortho11,'Position',[20 20 pos(3)/2 pos(4)],'Tag','Axes:Ortho11');
                set(findobj(ortho11,'Tag','Axis:Shape'),'Erasemode','normal')
                HAND    = getHandles(2,ortho11,[]);

                set(aniAxis     ,'Position',[40+pos(1)+pos(3)/2 pos(2) pos(3)/2 pos(4)]);
                set(findobj(aniAxis,'Tag','Axis:Shape'),'Erasemode','normal')
                HAND    = getHandles(1,aniAxis,HAND);
                
                camorbit(ortho11, SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
                camorbit(aniAxis,-SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
            case 'Red/Blue Glasses'
                val =[0 0 0 1];
                dPos    = get(aniAxis,'Position');

                ortho11 = copyobj(aniAxis,aniFig);
                pos     = get(ortho11,'Position');
                set(ortho11,'Position',dPos-[-5 0 0 0],'Tag','Axes:Ortho11');
                set(findobj(ortho11,'Tag','Axis:Shape'),'Erasemode','normal')
                HAND    = getHandles(2,ortho11,[]);
                chld    = get(ortho11,'Children');
                chld    = setdiff(chld,[HAND.Wire(:,2);HAND.Fill(:,2)]);
                set(chld,'Color',SETUP.Colors.RightEye);

                set(aniAxis     ,'Position',dPos+[5 0 0 0]);
                set(findobj(aniAxis,'Tag','Axis:Shape'),'Erasemode','normal')
                HAND    = getHandles(1,aniAxis,HAND);
                chld    = get(aniAxis,'Children');
                pchld   = findobj(aniAxis,'Type','Patch');
                chld    = setdiff(chld,[HAND.Wire(:,1);HAND.Fill(:,1)]);
                set(chld,'Color',SETUP.Colors.LeftEye);
                
                camorbit(ortho11, SETUP.View.CrosseyeAngle*2,0,'camera',SETUP.View.UpVector(2))
                camorbit(aniAxis,-SETUP.View.CrosseyeAngle*2,0,'camera',SETUP.View.UpVector(2))
        end
        str = {'off','on'};
        set(findobj(aniFig,'Tag','Menu:View:Single')    ,'Checked',str{val(1)+1});
        set(findobj(aniFig,'Tag','Menu:View:Quad')      ,'Checked',str{val(2)+1});
        set(findobj(aniFig,'Tag','Menu:View:Crosseyed') ,'Checked',str{val(3)+1});
        set(findobj(aniFig,'Tag','Menu:View:RedBlue')   ,'Checked',str{val(4)+1});
        UDATA.Handles.Markers   = HAND.Markers;
        UDATA.Handles.Labels    = HAND.Labels;
        UDATA.Handles.Conn      = HAND.Conn;
        UDATA.Handles.Static    = HAND.Static;
        UDATA.Handles.UCS       = HAND.UCS;
        UDATA.Handles.Wire      = HAND.Wire;
        UDATA.Handles.Fill      = HAND.Fill;
        UDATA.Handles.Mark      = HAND.Mark;
        if nargin<3;command('updatePrefs');end


    case 'Save'
        switch varargin{1}
            case 'Matlab'
                [file,path]=uiputfile([SETUP.Path.Data '*.mat'],'Export Matlab file...');
                if any([file==0,path==0])
                    path=[];file=[];
                    return;
                end
%                 [path,file,ext] = fileparts(fullfile(path,[file ext]));
                % Modified ABRA 18/2 -10: ext was not defined
                [path,file,ext] = fileparts(fullfile(path,[file]));
                save(fullfile(path,[file ext]),'GEOMETRY','MODAL');
                % Modified ABRA 18/2 -10: said = p, changed to path
                SETUP.Path.Data = path;
                SETUP   = updateRecentFiles(aniFig,fullfile(path,[file ext]),varargin{1},SETUP);
                defaults('addRecentFiles',SETUP);
                
            case 'UFF'
                [file,path]=uiputfile(fullfile(SETUP.Path.Data,'*.ufb'),'Export UFF binary file...');
                if any([file==0,path==0])
                    path=[];file=[];
                    return;
                end
                [p,n,e] = fileparts(fullfile(path,file));
                if ~strcmp(e,'.ufb')
                    file = [file '.ufb'];
                end
                % Headers
                for ii=1:length(UFF.dsn151)
                    uf{ii,1}    = UFF.DATA{UFF.dsn151(ii)};
                end
                % Units
                uf{end+1,1}     = UFF.DATA{min(UFF.dsn164)};
                % Nodes
                for ii=1:length(UFF.dsn15)
                    uf{end+1,1} = UFF.DATA{UFF.dsn15(ii)};
                    for node=1:length(uf{end}.Node)
                        uf{end}.Node(node).dispCS   = 0;
                    end
                end
                % Wireframe
                clrTable    = [0 0 0 ;10 10 10;1 0 0;0 1 0;0 0 1;0 1 1;1 0 1;1 1 0];
                for ii=1:length(UFF.dsn82)
                    clr = find(ismember(clrTable,SETUP.Component.Color(ii,:),'rows'))-1;
                    if isempty(clr)
                        % find closes
                        lst     = (clrTable-ones(8,1)*SETUP.Component.Color(1,:)).^2;
                        lstInd1 = find(min(lst(:,1))==lst(:,1));
                        lstInd2 = find(min(lst(:,2))==lst(:,2));
                        lstInd3 = find(min(lst(:,3))==lst(:,3));
                        rms     = sqrt(sum((clrTable-ones(8,1)*SETUP.Component.Color(1,:)).^2,2));
                        rmsInd  = find(min(rms)==rms);
                        ind     = [lstInd1;lstInd2;lstInd3;rmsInd];
                        uInd    = unique(ind);
                        for jj=1:length(uInd)
                            val(jj) = length(find(uInd(ii)==ind));
                        end
                        clr = uInd(min(find(max(val)==val)));
                        if isempty(clr)
                            clr = 0;
                        end
                    end
                    UFF.DATA{UFF.dsn82(ii)}.Color   = clr;
                    UFF.DATA{UFF.dsn82(ii)}.ID      = SETUP.Component.Name{ii};
                    uf{end+1,1} = UFF.DATA{UFF.dsn82(ii)};
                end
                % Modes
                for ii=1:length(MODAL)
                    base        = UFF.DATA{UFF.dsn55(ii)}; % 2012-01-13: bug fix changed 1 to ii so it goes through the modes. from 1 to ii. 
                    uf{end+1,1} = base;
                    uf{end,1}.UID   = [];
                    uf{end,1}.Real  = [real(MODAL(ii).Freq) imag(MODAL(ii).Freq) 0 0 0 0]*2*pi;
                    for node=1:length(MODAL(ii).Nodes)
                        NODE(node,1).Num    = MODAL(ii).Nodes(node);
                        NODE(node,1).Data   = MODAL(ii).Data(node,:);
                    end
                    uf{end,1}.Node  = NODE;
                end
                file    = fullfile(p,file);
                ufrw('save',file,uf,'binary');
                SETUP   = updateRecentFiles(aniFig,file,varargin{1},SETUP);
                defaults('addRecentFiles',SETUP);
            case 'Snapshot'
                str     = {'BMP monochrome';'BMP 24-bit';'EMF metafile';'EPS b&w';'EPS color';'EPS2 B&W';'EPS2 color';'JPEG 24-bit';'PCX 24-bit';'PDF color';'PNG 24-bit';'TIFF 24-bit'};
                eqv     = {'-dbmpmono';'-dbmp';'-dmeta';'-deps';'-depsc';'-deps2';'-depsc2';'-djpeg';'-dpcx24b';'-dpdf';'-dpng';'-dtiff'};
                xtn     = {'bmp';'bmp';'emf';'eps';'eps';'eps';'eps';'jpg';'pcx';'pdf';'png';'tif'};
                type    = find(ismember(str,SETUP.Snapshot.Format));
                str     = {'Z-buffer';'Open GL';'Painters'};
                rnd     = {'-zbuffer';'-opengl';'-painters'};
                rndType = find(ismember(str,SETUP.Snapshot.Renderer));
                if ~SETUP.Snapshot.DoAllModes
                    % Save current mode only
                    [file,path]=uiputfile(fullfile(SETUP.Path.Export,['*.' xtn{type}]),'Save snapshot...');
                    if any([file==0,path==0])
                        path=[];file=[];
                        return;
                    end
                    [path,file,ext]     = fileparts(fullfile(path,file));
                    if isempty(ext)
                        ext = xtn{type};
                    end
                    SETUP.Path.Export   = path;
                    fileName            = fullfile(path,[file ext]);
                    set(gcf,'PaperPositionMode','auto')
                    print(aniFig,['-r' num2str(SETUP.Snapshot.Resolution)],eqv{type},rnd{rndType},fileName)
                else
                    resp    = questdlg('Are you ready to save all modes to snapshots?','Snapshot Warning','Yes','No','No');
                    if strcmp(resp,'No')
                        return;
                    end
                    for mode = 1:length(MODAL);
                        set(findobj(gcf,'Tag','popup_modeList'),'Value',mode);
                        command('update_mode');
                        % Do AVI
                        fname       = sprintf('Mode%02d(%4.4fHz).%s',mode,imag(MODAL(mode).Freq),xtn{type});
                        fileName    = fullfile(SETUP.Path.Export,fname);
                        % Turn on toggle
                        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',1);
                        SETUP.Display.MaxDeflection   = 1;
                        retVal  = 1;
                        drawnow;
                        UDATA.ActiveFrame   = SETUP.Animation.MaxFrame-1;
                        while retVal
                            retVal  = animate_fcn;
                        end
                        set(aniFig,'InvertHardcopy','off');
                        print(aniFig,['-r' num2str(SETUP.Snapshot.Resolution)],eqv{type},rnd{rndType},fileName);
                        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
                    end
                end
            case 'AVI'
                if ~SETUP.AVI.DoAllModes
                    % Save current mode only
                    [file,path]=uiputfile(fullfile(SETUP.Path.Data,'*.avi'),'Save AVI file...');
                    if any([file==0,path==0])
                        path=[];file=[];
                        return;
                    end
                    try
                        [path,file,ext] = fileparts(fullfile(path,file));
                        fileName    = fullfile(path,[file ext]);
                        if length(fileName)>64
                            str = sprintf('AVI filenames are limited\nto a total length of 64 characters\n\n%s\n length = %d\n\nNot saving AVI.',fileName,length(fileName))
                            warndlg(str,'AVI Warning')
                            SETUP.AVI.On    = 0;
                            SETUP.AVI.Start = 0;
                            SETUP.AVI.Frame = 0;
                            SETUP.AVI.Movie = [];
                            return;
                        end
                        SETUP.AVI.FileName  = fileName;
                        SETUP.AVI.On        = 1;
                        UDATA.ActiveFrame   = floor(SETUP.Animation.Frames);
                        UDATA.Direction     = 1;
                        drawnow;
                        if ~get(findobj(aniFig,'Tag','Toggle:Animate'),'Value')
                            set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',1);
                            command('run_animate')
                        end
                    catch
                        warndlg(lasterr,'Animation')
                        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
                        SETUP.AVI.On    = 0;
                        SETUP.AVI.Start = 0;
                        SETUP.AVI.Frame = 0;
                        SETUP.AVI.Movie = [];
                    end
                else
                    % Save all modes
                    resp    = questdlg('Are you ready to save all modes to AVI?','AVI Warning','Yes','No','No');
                    if strcmp(resp,'No')
                        return;
                    end
                    for mode = 1:length(MODAL);
                        set(findobj(gcf,'Tag','popup_modeList'),'Value',mode);
                        command('update_mode');
                        % Do AVI
                        fname   = sprintf('Mode%02d(%4.4fHz).avi',mode,imag(MODAL(mode).Freq));
                        SETUP.AVI.FileName  = fullfile(SETUP.Path.Export,fname);
                        % Turn on toggle
                        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',1);
                        SETUP.AVI.On        = 1;
                        retVal              = 1;
                        UDATA.ActiveFrame   = floor(SETUP.Animation.Frames);
                        UDATA.Direction     = 1;
                        drawnow;
                        while retVal
                            retVal  = animate_fcn;
                        end
                        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
                    end
                end
        end
        if ishandle(findobj(0,'Tag','ANIMATE:PREFERENCES'))
            set(findobj(findobj(0,'Tag','ANIMATE:PREFERENCES'),'Tag','Preferences:EditExportPath'),'String',SETUP.Path.Export);
        end
        defaults('addRecentFiles',SETUP);
    case 'zoom'
        val = get(varargin{1},'Value');
        if val
            set(findobj(aniFig,'Tag','Toggle:Rotate'),'Value',0);
            view3d zoom;
        else
            view3d off;
        end

    case 'rotate'
        val = get(varargin{1},'Value');
        if val
            set(findobj(aniFig,'Tag','Toggle:Zoom'),'Value',0);
            view3d rot;
        else
            view3d off;
        end

    case 'set'
        switch varargin{1}
            case 'FPC'
                switch varargin{2}
                    case 'edit'
                        val = round(str2num(get(gcbo,'String')));
                        if isempty(val)
                            set(gcbo,'String',num2str(SETUP.Animation.Frames));
                            set(findobj(aniFig,'Tag','Slider:FPC'),'Value',SETUP.Animation.Frames);
                            return
                        end
                    case 'slider'
                        val = round(get(gcbo,'Value'));
                end
                SETUP.Animation.Frames  = min([max([3,val]),503]);
                set(findobj(aniFig,'Tag','Edit:FPC')    , 'String',num2str(SETUP.Animation.Frames));
                set(findobj(aniFig,'Tag','Slider:FPC')  , 'Value',SETUP.Animation.Frames);
                command('reset_animation');
            case 'amp'
                switch varargin{2}
                    case 'edit'
                        val = round(str2num(get(gcbo,'String'))*100)/100;
                        if isempty(val)
                            set(gcbo,'String',num2str(SETUP.Animation.Amplitude));
                            set(findobj(aniFig,'Tag','Slider:Amp'),'Value',SETUP.Animation.Amplitude);
                            return
                        end
                    case 'slider'
                        val = round(get(gcbo,'Value')*100)/100;
                end
                SETUP.Animation.Amplitude   = min([max([.01,val]),100.01]);
                set(findobj(aniFig,'Tag','Edit:Amp')    , 'String',num2str(SETUP.Animation.Amplitude));
                set(findobj(aniFig,'Tag','Slider:Amp')  , 'Value',SETUP.Animation.Amplitude);
                command('reset_animation');
                
            case 'deg'
                switch varargin{2}
                    case 'edit'
                        val = round(str2num(get(gcbo,'String')));
                        if isempty(val)
                            set(gcbo,'String',num2str(SETUP.Animation.Theta));
                            set(findobj(aniFig,'Tag','Slider:Deg'),'Value',SETUP.Animation.Theta);
                            return
                        end
                    case 'slider'
                        val = round(get(gcbo,'Value'));
                end
                SETUP.Animation.Theta   = min([max([-360,val]),360]);
                set(findobj(aniFig,'Tag','Edit:Deg')    , 'String',num2str(SETUP.Animation.Theta));
                set(findobj(aniFig,'Tag','Slider:Deg')  , 'Value',SETUP.Animation.Theta);
                command('reset_animation');
        end % END set
        %if nargin<3;command('updatePrefs');end
        command('updatePrefs')

    case 'Change'
        str     = {'off','on'};
        if nargin<3;
            eval(['SETUP.Display.' varargin{1} '=~SETUP.Display.' varargin{1} ';']);
            value   = eval(['SETUP.Display.' varargin{1} ';']);
            command('updatePrefs');
        else
            value   = varargin{2};
            eval(['SETUP.Display.' varargin{1} '=value;']);
        end
        set(findobj(aniFig,'Tag',['Menu:Display:' varargin{1}]),'Checked',str{value+1});
        command('on/off',varargin{1});

    case 'MultipleChange'
        str     = {'off','on'};
        switch varargin{1}
            case {'Real','Imaginary','Complex'}
                option  = {'Real','Imaginary','Complex'};
                value   = strcmp(option,varargin{1});
                SETUP.View.VectorType = option{find(value==1)};
            case {'+X','+Y','+Z'}
                option  = {'+X','+Y','+Z'};
                vectors = eye(3);
                value   = strcmp(option,varargin{1});
                SETUP.View.UpVector = option{find(value==1)};
                switch SETUP.View.Type
                    case 'Single'
                        view(aniAxis,[1,1])
                        set(aniAxis,'CameraUpVector',vectors(find(value==1),:));
                    case {'Cross-eyed','Red/Blue Glasses'}
                        view(aniAxis,[1,1])
                        set(aniAxis,'CameraUpVector',vectors(find(value==1),:));
                        set(findobj(aniFig,'Tag','Axes:Ortho11'),'CameraUpVector',vectors(find(value==1),:))
                    case 'Quad'
                        view(aniAxis,[1,1])
                        set(aniAxis,'CameraUpVector',vectors(find(value==1),:));
                        [VWS,CUV]   = viewSetup(1,1,SETUP.View.UpVector);
                        set(findobj(aniFig,'Tag','Axes:Ortho11'),'View',VWS,'CameraUpVector',CUV)
                        [VWS,CUV]   = viewSetup(2,3,SETUP.View.UpVector);
                        set(findobj(aniFig,'Tag','Axes:Ortho21'),'View',VWS,'CameraUpVector',CUV)
                        [VWS,CUV]   = viewSetup(3,4,SETUP.View.UpVector);
                        set(findobj(aniFig,'Tag','Axes:Ortho22'),'View',VWS,'CameraUpVector',CUV)
                end
        end
        for ii=1:length(option)
            set(findobj(aniFig,'Tag',['Menu:View:' option{ii}]),'Checked',str{value(ii)+1});
        end
        command('reset_animation');
        command('changeView')
        if nargin<3;command('updatePrefs');end

    case 'on/off'
        str     = {'off','on'};
        switch varargin{1}
            case 'Annotate'
                set(findobj(aniFig,'Tag','Text:Annotate'),'Visible',str{SETUP.Display.Annotate+1});
            case 'Static'
                set(UDATA.Handles.Static,'Visible',str{SETUP.Display.Static+1});
            case 'Labels'
                set(UDATA.Handles.Labels,'Visible',str{SETUP.Display.Labels+1});
            case 'Markers'
                set(UDATA.Handles.Markers,'Visible',str{SETUP.Display.Markers+1});
            case 'UCS'
                set(UDATA.Handles.UCS,'Visible',str{SETUP.Display.UCS+1});
        end
        if SETUP.Component.Open
            command('components','visible',find(SETUP.Component.Visible),1);
            if ~SETUP.Component.Wireframe
                set(UDATA.Handles.Markers,'Visible','off');
            end
        end
        if nargin<3;command('updatePrefs');end

    case 'reset_animation'
        MAX=max(max(abs(MODAL(SETUP.Animation.ModeNr).Data)))./SETUP.Animation.Amplitude;
        vector.x=MODAL(SETUP.Animation.ModeNr).Data(:,1)./MAX;
        vector.y=MODAL(SETUP.Animation.ModeNr).Data(:,2)./MAX;
        vector.z=MODAL(SETUP.Animation.ModeNr).Data(:,3)./MAX;
        [ANIMATION,NODES]=set_mode(vector);

        % Set Axis Limits
        maxX    = max(max([ANIMATION.X]));
        maxY    = max(max([ANIMATION.Y]));
        maxZ    = max(max([ANIMATION.Z]));
        scl     = 0.01;
        maxX    = maxX*(1+sign(maxX)*scl);
        maxY    = maxY*(1+sign(maxX)*scl);
        maxZ    = maxZ*(1+sign(maxX)*scl);

        minX=min(min([ANIMATION.X]));
        minY=min(min([ANIMATION.Y]));
        minZ=min(min([ANIMATION.Z]));
        minX    = minX*(1-sign(minX)*scl);
        minY    = minY*(1-sign(minX)*scl);
        minZ    = minZ*(1-sign(minX)*scl);
        X   = [minX maxX];
        Y   = [minY maxY];
        Z   = [minZ maxZ];
        if diff(X)==0 | max(isnan(X))
            X   = [min(min([ANIMATION.X])) max(max([ANIMATION.X]))]+[-1e-8 1e-8];
        end
        if diff(Y)==0 | max(isnan(Y))
            Y   = [min(min([ANIMATION.Y])) max(max([ANIMATION.Y]))]+[-1e-8 1e-8];
        end
        if diff(Z)==0 | max(isnan(Z))
            Z   = [min(min([ANIMATION.Z])) max(max([ANIMATION.Z]))]+[-1e-8 1e-8];
        end
        % MATLAB Version changes
        axs = findobj(aniFig,'Type','Axes');
        for ii=1:length(axs)
            %axis(aniAxis,[minX maxX minY maxY minZ maxZ])
            set(axs(ii),'Xlim',X,'Ylim',Y,'Zlim',Z)
        end


    case 'geo/con'  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        warning off;
        set(aniAxis,'CameraViewAngleMode','auto');
        ii=0;
        delete(get(aniAxis,'Children'));
        axis(aniAxis,[-1 1 -1 1 -1 1]);
        hold on
        temp=1:length(GEOMETRY.node);
        ind=temp(ismember(GEOMETRY.node,unique(GEOMETRY.conn(~isnan(GEOMETRY.conn)))));
        for i=1:length(ind)
            DATA.PNodes(i,1)= GEOMETRY.node(ind(i));
            DATA.Plot(i,1)  = GEOMETRY.x(ind(i));
            DATA.Plot(i,2)  = GEOMETRY.y(ind(i));
            DATA.Plot(i,3)  = GEOMETRY.z(ind(i));
            DATA.Text(i,1)  = text(DATA.Plot(i,1),DATA.Plot(i,2),DATA.Plot(i,3),[' ' num2str(GEOMETRY.node(ind(i)))]);
            labelText(i,1)  = GEOMETRY.node(ind(i));
            set(DATA.Text(i,1),'Color',SETUP.Colors.Labels,'erasemode','normal','Fontsize',7,'Tag','Axis:Label');  % Text color is black
        end
        view(aniAxis,[135 35]);

        % Use single plot command to plot node markers and make markers light purple
        DATA.Plot(end+1,:)=[NaN NaN NaN];
        DATA.Point(1,1)=plot3(DATA.Plot(:,1),DATA.Plot(:,2),DATA.Plot(:,3),'.');
        set(DATA.Point,'Color',SETUP.Colors.Markers,'erasemode','normal','MarkerSize',5,'Tag','Axis:Node'); % Black Lines
        hold off
        conn=[];
        for ii=1:length(GEOMETRY.conn);
            if isnan(GEOMETRY.conn(ii))
                conn(ii)=length(DATA.Plot);
            else
                conn(ii)=find(DATA.PNodes==GEOMETRY.conn(ii));
            end
        end
        static_handle=line(DATA.Plot(conn,1),DATA.Plot(conn,2),DATA.Plot(conn,3),'Erasemode','normal','Color',SETUP.Colors.Static,'LineStyle','-','Tag','Axis:Static');
        conn_handle  =line(DATA.Plot(conn,1),DATA.Plot(conn,2),DATA.Plot(conn,3),'Erasemode','normal','Color',SETUP.Colors.Shape,'Tag','Axis:Shape');
        UDATA.ConnList=conn;
        %=================================================
        %=================================================
        SETUP.Component.Handle=[];
        compInd     = [];
        fillHand    = [];
        SETUP.Component.FillHandle      = [];
        SETUP.Component.FillComps       = [];
        SETUP.Component.FillConn        = [];
        connData                        = [];
        for comp=1:size(SETUP.Component.Name,1)
            CONN    = SETUP.Component.Nodes{comp,1};
            conn    = [];
            for ii=1:length(CONN);
                if isnan(CONN(ii))
                    conn(ii)=length(DATA.Plot);
                else
                    conn(ii)=find(DATA.PNodes==CONN(ii));
                end
            end
            ind = find(conn==max(conn));
            if ind(1)~=1
                ind     = [1 ind];
                conn    = [max(conn) conn];
            end
            ind = find(conn==max(conn));
            if ind(end)~=length(conn)
                ind     = [ind length(conn)+1];
                conn    = [conn max(conn)];
            end
            set(gca,'NextPlot','add');
            fillHand    = [];
            fillInd     = [];
            for ii=1:length(ind)-1
                connList            = conn(ind(ii)+1:ind(ii+1)-1);
                fillInd             = [fillInd;connList.'];
                fill_handle         = fill3(DATA.Plot(connList,1),DATA.Plot(connList,2),DATA.Plot(connList,3),SETUP.Component.Color(comp,:));
                fillHand            = [fillHand;fill_handle];
                compInd             = [compInd;1*comp];
                connData{end+1,1}   = connList;
                set(fill_handle,'Edgecolor',SETUP.Colors.Shape,'Erasemode','normal','Tag','Axis:Fill','visible','off');
            end
            SETUP.Component.MarkHandle(comp,1)  = plot3(DATA.Plot(conn,1),DATA.Plot(conn,2),DATA.Plot(conn,3),'.','Color',SETUP.Component.Color(comp,:),'Erasemode','normal','Tag','Axis:Mark','Visible','off','MarkerSize',5);
            SETUP.Component.WireHandle(comp,1)  = line( DATA.Plot(conn,1),DATA.Plot(conn,2),DATA.Plot(conn,3)    ,'Color',SETUP.Component.Color(comp,:),'Erasemode','normal','Tag','Axis:Wire','Visible','off');
            SETUP.Component.WireIndex{comp,1}   = conn;
            SETUP.Component.FillHandle          = [SETUP.Component.FillHandle;fillHand];
            SETUP.Component.FillComps           = compInd;
        end
        SETUP.Component.FillConn            = connData;
        set(gca,'NextPlot','replace');
        %=================================================
        %=================================================

        % Add a UCS to Fig
        mval    = max([max(GEOMETRY.x)-min(GEOMETRY.x) max(GEOMETRY.y)-min(GEOMETRY.y) max(GEOMETRY.z)-min(GEOMETRY.z)]);
        scl=.075;
        ucs=[0 0 0;
            [1 0 0]*mval*scl;
            [0 1 0]*mval*scl;
            [0 0 1]*mval*scl;
            NaN NaN NaN];
        conn=[2 1 3 5 4 1];
        ucs_handle=line(ucs(conn,1),ucs(conn,2),ucs(conn,3),'Erasemode','normal','Color',SETUP.Colors.UCS,'Tag','Axis:UCS');
        str={'X','Y','Z'};
        for ii=1:3
            t_hand(1,ii)=text(ucs(ii+1,1),ucs(ii+1,2),ucs(ii+1,3),str{ii});
            set(t_hand(1,ii),'Color',[.1 .1 1],'erasemode','normal','Fontsize',7,'Tag','Axis:UCS');
        end

        % Scale axis to 2*prct in X,Y,& Z
        axis equal;
        ax=axis;
        prct=0.02;
        axis([ax(1)-(ax(2)-ax(1))*prct ax(2)+(ax(2)-ax(1))*prct,...
            ax(3)-(ax(4)-ax(3))*prct ax(4)+(ax(4)-ax(3))*prct,...
            ax(5)-(ax(6)-ax(5))*prct ax(6)+(ax(6)-ax(5))*prct])

        UDATA.Handles.Markers   = DATA.Point;
        UDATA.Handles.Labels    = DATA.Text;
        UDATA.Handles.Conn      = conn_handle;
        UDATA.Handles.Static    = static_handle;
        UDATA.Handles.UCS       = [ucs_handle t_hand];
        UDATA.Handles.Wire      = SETUP.Component.WireHandle;
        UDATA.Handles.Mark      = SETUP.Component.MarkHandle;
        UDATA.Handles.Fill      = SETUP.Component.FillHandle;
        UDATA.Geometry          = DATA.Plot;
        UDATA.Text              = labelText;
        UDATA.ActiveFrame       = 1;
        UDATA.Direction         = 1;
        UDATA.Frames            = SETUP.Animation.Frames;

        command('on/off','Labels');
        command('on/off','Markers');
        command('on/off','Static');
        command('on/off','UCS');
        set(aniAxis,'CameraViewAngleMode','manual');
        command('MultipleChange',SETUP.View.UpVector);
        warning on;

    case 'changeView'  %===================================================
        if nargin==1
            value   = SETUP.View.Axis;
        else
            value   = varargin{1};
        end
        SETUP.View.Axis = value;
        switch value
            case 'X'
                val = [1 0 0 0];
                [VWS,CUV] = viewSetup(3,1,SETUP.View.UpVector);
                view(aniAxis,VWS)
            case 'Y'
                val = [0 1 0 0];
                [VWS,CUV] = viewSetup(2,1,SETUP.View.UpVector);
                view(aniAxis,VWS)
            case 'Z'
                val = [0 0 1 0];
                [VWS,CUV] = viewSetup(1,1,SETUP.View.UpVector);
                set(aniAxis,'View',VWS);
            case 'Ortho'
                val = [0 0 0 1];
                [VWS,CUV] = viewSetup(1,2,SETUP.View.UpVector);
                set(aniAxis,'View',[135 35],'CameraUpVector',CUV);
        end
        switch SETUP.View.Type
            case 'Cross-eyed'
                ortho11 = findobj(aniFig,'Tag','Axes:Ortho11');
                switch value
                    case {'X','Y','Z'}
                        view(ortho11,VWS);
                        camorbit(ortho11, SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
                        camorbit(aniAxis,-SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
                    otherwise
                        set(ortho11,'View',[135 35],'CameraUpVector',CUV);
                        camorbit(ortho11, SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
                        camorbit(aniAxis,-SETUP.View.CrosseyeAngle,0,'camera',SETUP.View.UpVector(2))
                end
            case 'Red/Blue Glasses'
                command('updateRotate')
        end
        str     = {'off','on'};
        uiStr   = {'X';'Y';'Z';'Ortho'};
        for ii=1:4;
            set(findobj(aniFig,'tag',['ContextMenu\Axes\' uiStr{ii}])   ,'Checked',str{val(ii)+1});
            set(findobj(aniFig,'tag',['Menu:View:' uiStr{ii}])          ,'Checked',str{val(ii)+1});
        end
        if nargin<3;command('updatePrefs');end


    case 'close'
        switch varargin{1}
            case 'main'
%                 resp    = questdlg('Exit Animation?','Animation','Yes','No','No');
%                 if strcmp(resp,'No')
%                     return;
%                 end
                set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
                command('close','preferences');
                command('close','about');
                command('close','components');
                delete(aniFig);
            case 'components'
                compFig = findobj(0,'Tag','ANIMATE:COMPONENTS');
                SETUP.Component.Open    = 0;
                if ~isempty(UDATA.Handles)
                    set(UDATA.Handles.Conn,'Visible','on');
                    command('components','visible',[1:size(SETUP.Component.Name,1)],0);
                    command('components','fill'   ,[1:size(SETUP.Component.Name,1)],0);
                    if SETUP.Display.Labels
                        set(UDATA.Handles.Labels,'Visible','on');
                    end
                    if SETUP.Display.Markers
                        set(UDATA.Handles.Markers,'Visible','on');
                    end
                end
                set(findobj(aniFig,'Tag','Menu:View:RedBlue'),'Enable','on');
                delete(compFig);
            case 'preferences'
                prefFig = findobj(0,'Tag','ANIMATE:PREFERENCES');
                delete(prefFig);
            case 'about'
                abtFig  = findobj(0,'Tag','ANIMATE:ABOUT');
                delete(abtFig);
        end


    case 'resize'
        RESIZE.FigPos=get(aniFig,'Position');
        POS=get(aniFig,'Position');
        dy=POS(4)-RESIZE.FigPos(4);
        x =POS(3);
        objects=findobj(aniFig,'Type','uicontrol');
        for ii=1:length(objects);
            pos=get(objects(ii),'Position');
            if strcmp(get(objects(ii),'Tag'),'Frame:Controls')
                set(objects(ii),'Position',[pos(1), pos(2)+dy, x+2 pos(4)]);
            else
                set(objects(ii),'Position',[pos(1), pos(2)+dy, pos(3) pos(4)]);
            end
        end
        RESIZE.FigPos=get(aniFig,'Position');
        if strcmp(SETUP.View.Type,'Quad');
            set(aniAxis,'Units','pixels','Position',[20, 20, POS(3)-70, POS(4)-125]);
            set(findobj(aniFig,'Tag','Axes:Ortho11'),'Units','pixels','Position',[20, 20+(POS(4)-125)/2, (POS(3)-70)/2, (POS(4)-125)/2]);
            set(findobj(aniFig,'Tag','Axes:Ortho21'),'Units','pixels','Position',[20, 20, (POS(3)-70)/2, (POS(4)-125)/2]);
            set(findobj(aniFig,'Tag','Axes:Ortho22'),'Units','pixels','Position',[25+(POS(3))/2, 20, (POS(3)-70)/2, (POS(4)-125)/2]);
            set(aniAxis,'Units','pixels','Position',[25+(POS(3))/2, 20+(POS(4)-125)/2, (POS(3)-70)/2, (POS(4)-125)/2]);
        elseif strcmp(SETUP.View.Type,'Cross-eyed');
            set(findobj(aniFig,'Tag','Axes:Ortho11'),'Units','pixels','Position',[20, 20, (POS(3)-70)/2, (POS(4)-125)]);
            set(aniAxis,'Units','pixels','Position',[25+(POS(3))/2, 20, (POS(3)-70)/2, (POS(4)-125)]);

        elseif strcmp(SETUP.View.Type,'Red/Blue Glasses');
            set(findobj(aniFig,'Tag','Axes:Ortho11'),'Units','pixels','Position',[15, 20, POS(3)-70, POS(4)-125]);
            set(aniAxis,'Units','pixels','Position',[25, 20, POS(3)-70, POS(4)-125]);
            
        else
            set(aniAxis,'Units','pixels','Position',[20, 20, POS(3)-70, POS(4)-125]);
        end
        
    case 'recentFile'
        ii=varargin{1};
        command('Load',eval(['SETUP.RecentFiles.Type' ii]),eval(['SETUP.RecentFiles.File' ii]),str2num(ii));

    case 'Load'
        if all([~strcmp(SETUP.View.Type,'Single'),~isempty(GEOMETRY)])
            quadTemp    = SETUP.View.Type;
            command('viewType','Single');
        else
            quadTemp    = [];
        end
        if ishandle(findobj(0,'Tag','ANIMATE:COMPONENTS'))
            compTemp    = 1;
            compPos     = get(findobj(0,'Tag','ANIMATE:COMPONENTS'),'Position');
            command('close','components');
            SETUP.Component.Open    = 0;
        else
            compTemp    = 0;
        end
        if ismember(SETUP.Colors.Background,[0 0 0],'rows')
            clrTable = [1 1 1;1 1 1];
        elseif ismember(SETUP.Colors.Background,[1 1 1],'rows')
            clrTable = [0 0 0;0 0 0];
        else
            clrTable = [0 0 0;1 1 1];
        end
        clrTable    = [clrTable;1 0 0;0 1 0;0 0 1;0 1 1;1 0 1;1 1 0];
        switch varargin{1}
            case 'Matlab'
                errFlg  = [];
                if nargin==2
                    [file,path]=uigetfile(fullfile(SETUP.Path.Data,'*.mat'),'Select data file...');
                    if any([file==0,path==0]);
                        return;
                    end
                    file    = fullfile(path,file);
                else
                    file    = varargin{2};
                end
                if ~exist(file,'file')
                    errordlg('Error finding file.','Animation');
                    return
                end
                try
                    D   = load(file,'-mat');
                catch
                    errFlg{1}   = 'Error loading file.';
                    errFlg{2}   = lasterr;
                end
                try
                    GEOMETRY    = D.GEOMETRY;
                    M           = D.MODAL;
                catch
                    errFlg{1}   = 'Invalid animation file.';
                    errFlg{2}   = lasterr;
                end
                if ~isempty(errFlg)
                    errordlg(errFlg,'Animation');
                    return
                end
                set(findobj(aniFig,'Tag','Text:LoadGeom'),'String',file);

                % VECTORS
                ModalNodes  = M(1).Node;
                temp        = 1:length(GEOMETRY.node);
                ind1        = temp(ismember(GEOMETRY.node,unique(GEOMETRY.conn(~isnan(GEOMETRY.conn)))));
                GeomNodes   = GEOMETRY.node(ind1);
                for ii=1:length(GeomNodes)
                    ind(ii,1)=find(GeomNodes(ii)==ModalNodes);
                end
                [Y,FreqInd]=sort(imag([M.Freq]));
                for ii=1:length(M);
                    MODAL(ii).Freq  = M(FreqInd(ii)).Freq;
                    MODAL(ii).Data  = [M(FreqInd(ii)).X(ind) M(FreqInd(ii)).Y(ind) M(FreqInd(ii)).Z(ind)];
                    MODAL(ii).Nodes = ModalNodes(ind);
                    str{ii,1}       = sprintf('(%02d) %8.3f',ii,2*pi*poles2fz(MODAL(ii).Freq));  % Bugfix 2018-05-10 to print actual undamped natural frequency in 'Mode List'
                end
                [Path,File,Ext]         = fileparts(file);
                SETUP.Path.Data         = Path;
                SETUP.Path.ModalFile    = [File,Ext];
                SETUP.Animation.ModeNr  = 1;
                set(findobj(aniFig,'Tag','Text:LoadVectors'),'String',file);
                set(findobj(aniFig,'Tag','popup_modeList')  ,'Value',1,'String',str,'Enable','on');
                UFF = createUFF(GEOMETRY,MODAL,SETUP,UFF);
                SETUP.Component.Name    = {'None'};
                SETUP.Component.Color   = [0 0 0];
                SETUP.Component.Nodes   = {GEOMETRY.conn};
                SETUP.Component.Visible = 1;
                SETUP.Component.Fill    = 0;

            case 'UFF'
                errFlg      = [];
                if nargin==2
                    [file,path] =uigetfile(fullfile(SETUP.Path.Data,'*.u*'),'Select UF file...');
                    if any([file==0,path==0]);
                        return;
                    end
                    file    = fullfile(path,file);
                else
                    file    = varargin{2};
                end
                if ~exist(file,'file')
                    errordlg('Error finding file.','Animation');
                    return
                end
                
                try 
                    [U,dsn] = ufrw('load',file);
                catch
                    errFlg  = 'Invalid universal file.';
                end
                if ~isempty(errFlg)
                    errordlg(errFlg,'Animation');
                    return
                end
                modeGroups  = find(dsn==55);
                geom        = find(dsn==15);
                conn        = find(dsn==82);
                if isempty(modeGroups)
                    errFlg{end+1,1}   = 'File contains no mode groups (DSN 55).';
                end
                if isempty(geom)
                    errFlg{end+1,1}   = 'File contains no geometry (DSN 15).';
                end
                if isempty(conn)
                    errFlg{end+1,1}   = 'File contains no wireframe (DSN 82).';
                end
                if ~isempty(errFlg)
                    errordlg(errFlg,'Animation');
                    return
                end
                GEOMETRY    = [];
                MODAL       = [];
                UFF.DATA    = U;
                UFF.dsn15   = geom;
                UFF.dsn18   = find(dsn==18);
                UFF.dsn55   = modeGroups;
                UFF.dsn82   = conn;
                UFF.dsn151  = find(dsn==151);
                UFF.dsn164  = find(dsn==164);
                ref18   = [];
                for ii=1:length(UFF.dsn18)
                    ref18(ii)       = U{UFF.dsn18(ii)}.CS.Number;
                    org             = U{UFF.dsn18(ii)}.CS.Origin;
                    xax             = U{UFF.dsn18(ii)}.CS.Xaxis;
                    xzp             = U{UFF.dsn18(ii)}.CS.XZplane;
                    X               = (xax-org)./norm((xax-org));
                    XZp             = (xzp-org)./norm((xzp-org));
                    Y               =-cross(X,XZp)./norm(cross(X,XZp));
                    Z               = cross(X,Y);
                    Tx(:,:,ii)      = [X;Y;Z];
                    %TxOrg(:,:,ii)   = Tx(:,:,ii);
                    CSType(ii,1)    = U{UFF.dsn18(ii)}.CS.Type;
                    CSOffset(ii,:)  = org;
                    Xaxis(ii,:)     = xax;
                    XZplane(ii,:)   = xzp;
                end

                for ii=1:length(U{geom}.Node)
                    if U{geom}.Node(ii).defCS>0
                        % Cylidrical
                        ind  = min(find(ref18==U{geom}.Node(ii).defCS));
                        if isempty(ind)
                            warndlg(sprintf('Refernce CS : %d not found.\nNode : %d is in global.',U{geom}.Node(ii).defCS,U{geom}.Node(ii).Label),'Universal file...');
                            x   = U{geom}.Node(ii).Crd(1);
                            y   = U{geom}.Node(ii).Crd(2);
                            z   = U{geom}.Node(ii).Crd(3);
                        else
                            if CSType(ind,1)==1
                                % Cylindrical
                                % ASSUME THAT DEF IS R, THETA, Z;
                                theta   = U{geom}.Node(ii).Crd(2)*pi/180;
                                tx      = [cos(theta) sin(theta) 0;-sin(theta) cos(theta) 0;0 0 1];
                                x   = U{geom}.Node(ii).Crd(1)*cos(theta);
                                y   = U{geom}.Node(ii).Crd(1)*sin(theta);
                                z   = U{geom}.Node(ii).Crd(3);
                                val = [x y z]*Tx(:,:,ind);
                                x   = val(1);
                                y   = val(2);
                                z   = val(3);
                            else
                                % Spherical
                            end
                        end
                    else
                        x   = U{geom}.Node(ii).Crd(1);
                        y   = U{geom}.Node(ii).Crd(2);
                        z   = U{geom}.Node(ii).Crd(3);
                    end
                    GEOMETRY.node(ii)  = U{geom}.Node(ii).Label;
                    GEOMETRY.x(ii)     = x;
                    GEOMETRY.y(ii)     = y;
                    GEOMETRY.z(ii)     = z;
                    if U{geom}.Node(ii).dispCS>0 & ~isempty(ref18)
                        ind  = min(find(ref18==U{geom}.Node(ii).dispCS));
                        if isempty(ind)
                            warndlg(sprintf('Cannot find dsn18 ref for dispCS "%d" : Node "%d"\nDefault is global.',U{geom}.Node(ii).dispCS,U{geom}.Node(ii).Label))
                            GEOMETRY.Tx(:,:,ii)  = eye(3);
                        else
                            GEOMETRY.Tx(:,:,ii)  = tx*Tx(:,:,ind);
                        end
                    else
                        GEOMETRY.Tx(:,:,ii)  = eye(3);
                    end
                end
                CONN=[];
                dmy = 0;
                for ii=1:length(conn)
                    temp=U{conn(ii)}.Trace;
                    temp(find(temp==-1))    = NaN;
                    temp(find(temp== 0))    = NaN;
                    if ~isempty(temp)
                        dmy = dmy+1;
                        CONN        = [CONN temp NaN];
                        CNN{dmy,1}  = [temp NaN];
                        while U{conn(ii)}.Color+1>8
                            U{conn(ii)}.Color   = U{conn(ii)}.Color-8;
                        end
                        CLR(dmy,:)  = clrTable(U{conn(ii)}.Color+1,:);
                        NAME{dmy,1} = U{conn(ii)}.ID;
                    end
                end
                GEOMETRY.conn=CONN;
                % group by components
                unames  = unique(NAME);
                SETUP.Component.Name    = NAME;
                SETUP.Component.Color   = CLR;
                SETUP.Component.Nodes   = CNN;
                SETUP.Component.Visible = ones(size(CNN,1),1);
                SETUP.Component.Fill    = zeros(size(CNN,1),1);

                NrPts   = length([U{modeGroups(1)}.Node.Num]);
                for ii=1:length(modeGroups)
                    freq(ii,1)  = U{modeGroups(ii)}.Real(2);
                end
                indPos  = find(freq>0);
                MODAL   = [];
                for ii=1:length(indPos)
                    Data   = reshape([U{modeGroups(indPos(ii))}.Node.Data],3,NrPts)';
                    MODAL(ii).Node  = [U{modeGroups(indPos(ii))}.Node.Num]';
                    for nn=1:size(Data,1)
                        ind  = find(MODAL(ii).Node(nn)==GEOMETRY.node);
                        if ~isempty(ind)
                            Data(nn,:)   = Data(nn,:)*GEOMETRY.Tx(:,:,ind);
                        end
                    end
                    MODAL(ii).X     = Data(:,1);
                    MODAL(ii).Y     = Data(:,2);
                    MODAL(ii).Z     = Data(:,3);
                    MODAL(ii).Freq  = [U{modeGroups(indPos(ii))}.Real(1)+j*U{modeGroups(indPos(ii))}.Real(2)]./2/pi;
                end
                M           = MODAL;
                ModalNodes  = M(1).Node;
                temp        = 1:length(GEOMETRY.node);
                ind1        = temp(ismember(GEOMETRY.node,unique(GEOMETRY.conn(~isnan(GEOMETRY.conn)))));
                GeomNodes   = GEOMETRY.node(ind1);
                for ii=1:length(GeomNodes)
                    ind(ii,1)=find(GeomNodes(ii)==ModalNodes);
                end
                [Y,FreqInd]=sort(imag([M.Freq]));
                for ii=1:length(M);
                    MODAL(ii).Freq  = M(FreqInd(ii)).Freq;
                    MODAL(ii).Data  = [M(FreqInd(ii)).X(ind) M(FreqInd(ii)).Y(ind) M(FreqInd(ii)).Z(ind)];
                    MODAL(ii).Nodes = ModalNodes(ind);
                    str{ii,1}       = sprintf('(%02d) %8.3f',ii,imag(MODAL(ii).Freq));
                end
                set(findobj(aniFig,'Tag','popup_modeList'),'Value',1,'String',str,'Enable','on');
                [Path,File,Ext]         = fileparts(file);
                SETUP.Path.Data         = Path;
                SETUP.Path.ModalFile    = [File,Ext];
                SETUP.Animation.ModeNr  = 1;
                set(findobj(aniFig,'Tag','Menu:Display:Components'),'Enable','on');
        end
        command('geo/con');
        command('update_mode');
        set(findobj(aniFig,'Tag','Toggle:Animate')  ,'Enable','on');
        set(findobj(aniFig,'Tag','Toggle:Zoom')     ,'Enable','on');
        set(findobj(aniFig,'Tag','Toggle:Rotate')   ,'Enable','on');
        set(findobj(aniFig,'Tag','Menu:Display')    ,'Enable','on');
        set(findobj(aniFig,'Tag','Menu:View')       ,'Enable','on');
        set(findobj(aniFig,'Tag','Menu:File:Save')  ,'Enable','on');
        if ~isempty(quadTemp)
            command('viewType',quadTemp)
        end
        if compTemp & strcmp(varargin{1},'UFF')
            command('components','init',compPos);
        end
        SETUP   = updateRecentFiles(aniFig,file,varargin{1},SETUP);
        defaults('addRecentFiles',SETUP);
        set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',1);
        command('run_animate');

    case 'update_mode'
        val=get(findobj(aniFig,'Tag','popup_modeList'),'Value');
        SETUP.Animation.ModeNr=val;
        if imag(MODAL(val).Freq)>0
            SIGN='-';
        else
            SIGN='+';
        end
        str=sprintf('%s\nMode Nr: %02d\nFreq (Hz): %8.3f% 1s%8.3fi',SETUP.Path.ModalFile,val,real(MODAL(val).Freq),SIGN,abs(imag(MODAL(val).Freq)));
        set(findobj(aniFig,'Tag','Text:Annotate'),'String',str);
        command('reset_animation');


    case 'set_vectorType'
        val=get(findobj(aniFig,'Tag','Popup:vectorType'),'Value');
        str=get(findobj(aniFig,'Tag','Popup:vectorType'),'String');
        SETUP.View.VectorType=str{val};
        command('update_mode');
        if nargin<3;command('updatePrefs');end
end  % End Switch(action)

%==========================================================================
function [VWS,CUV] = viewSetup(pV,pC,upVector)
T       = eye(3);
str     = {'+X','+Y','+Z'};
vw      = [90,0;0,0;0,90];
vw(:,:,1)   = [90 0;180 0;0 90];
vw(:,:,2)   = [180 0;0 90;90 0];
vw(:,:,3)   = [180 90;90 0;180 0];
vals    = [1 2 3;2 3 1;3 1 2];
VWS     = vw(:,:,find(ismember(str,upVector)));

% GCA Camera Up Values
cuv(:,:,1)  = [0 -1 0;1 0 0; 1  0  0;1 0 0]; % +X Up view
cuv(:,:,2)  = [0 0 -1;0 1 0; 0 1  0;0 1 0]; % +Y Up view
cuv(:,:,3)  = [-1 0 0;0 0 1; 0 0 1;0 0 1]; % +Z Up view
CUV         = cuv(:,:,find(ismember(str,upVector)));

VWS = VWS(pV,:);
CUV = CUV(pC,:);


%==========================================================================
function [ANI,Nodes]=set_mode(vector)
global UDATA SETUP MODAL
aniFig          = findobj(0,'Tag','ANIMATE');
aniAxis         = findobj(aniFig,'Tag','Axes:Single');
UDATA.Frames    = SETUP.Animation.Frames;

if UDATA.ActiveFrame>UDATA.Frames
   UDATA.ActiveFrame=ceil(UDATA.Frames/2);
end

msx=[vector.x;NaN];
msy=[vector.y;NaN];
msz=[vector.z;NaN];
switch SETUP.View.VectorType
case 'Real'
    msx=real(msx);
    msy=real(msy);
    msz=real(msz);
    
case 'Imaginary'
    msx=imag(msx);
    msy=imag(msy);
    msz=imag(msz);
    
end
% complex loop from -max to +max with a phase difference added
temp.X=vecompspace(abs(msx),angle(msx),UDATA.Frames)+UDATA.Geometry(:,1)*ones(1,UDATA.Frames);
temp.Y=vecompspace(abs(msy),angle(msy),UDATA.Frames)+UDATA.Geometry(:,2)*ones(1,UDATA.Frames);
temp.Z=vecompspace(abs(msz),angle(msz),UDATA.Frames)+UDATA.Geometry(:,3)*ones(1,UDATA.Frames);

xx  = abs(temp.X(1:end-1,:)-UDATA.Geometry(1:end-1,1)*ones(1,UDATA.Frames));
yy  = abs(temp.Y(1:end-1,:)-UDATA.Geometry(1:end-1,1)*ones(1,UDATA.Frames));
zz  = abs(temp.Z(1:end-1,:)-UDATA.Geometry(1:end-1,1)*ones(1,UDATA.Frames));
a   = sqrt(sum(xx.^2+yy.^2+zz.^2,1));
ind = find(a==max(a));
SETUP.Animation.MaxFrame    = min(ind);

for fr=1:UDATA.Frames
   Nodes(:,1:3,fr)      = [temp.X(1:end-1,fr) temp.Y(1:end-1,fr) temp.Z(1:end-1,fr)];
   CompNodes(:,1:3,fr)  = [[temp.X(1:end-1,fr);NaN] [temp.Y(1:end-1,fr);NaN] [temp.Z(1:end-1,fr);NaN]];
   ANI(1,fr).X          = temp.X(UDATA.ConnList,fr);
   ANI(1,fr).Y          = temp.Y(UDATA.ConnList,fr);
   ANI(1,fr).Z          = temp.Z(UDATA.ConnList,fr);
end
NUDATA.ANI      = ANI;
NUDATA.NODES    = Nodes;
NUDATA.CompNodes= CompNodes;

set(aniAxis,'Userdata',NUDATA);


%==========================================================================
function HAND = getHandles(pos,ax,HAND,varargin);
if nargin>3
    HAND.Conn       = findobj(ax,'Tag','Axis:Shape');
    HAND.Static     = findobj(ax,'Tag','Axis:Static');
    HAND.Markers    = findobj(ax,'Tag','Axis:Node');
    HAND.UCS        = findobj(ax,'Tag','Axis:UCS');
    HAND.Labels     = findobj(ax,'Tag','Axis:Label');
    HAND.Wire       = flipud(findobj(ax,'Tag','Axis:Wire'));
    HAND.Mark       = flipud(findobj(ax,'Tag','Axis:Mark'));
    HAND.Fill       = flipud(findobj(ax,'Tag','Axis:Fill'));
else
    HAND.Conn(pos)      = findobj(ax,'Tag','Axis:Shape');
    HAND.Static(pos)    = findobj(ax,'Tag','Axis:Static');
    HAND.Markers(pos)   = findobj(ax,'Tag','Axis:Node');
    HAND.UCS(pos,:)     = findobj(ax,'Tag','Axis:UCS');
    HAND.Labels(:,pos)  = findobj(ax,'Tag','Axis:Label');
    HAND.Wire(:,pos)    = flipud(findobj(ax,'Tag','Axis:Wire'));
    HAND.Mark(:,pos)    = flipud(findobj(ax,'Tag','Axis:Mark'));
    HAND.Fill(:,pos)    = flipud(findobj(ax,'Tag','Axis:Fill'));
end

%==========================================================================
function SETUP = updateRecentFiles(aniFig,file,type,SETUP);
files   = {SETUP.RecentFiles.File1;SETUP.RecentFiles.File2;SETUP.RecentFiles.File3;SETUP.RecentFiles.File4};
ind     = find(ismember(files,file));
if isempty(ind)
    SETUP.RecentFiles.File4 = SETUP.RecentFiles.File3;
    SETUP.RecentFiles.Type4 = SETUP.RecentFiles.Type3;
    SETUP.RecentFiles.File3 = SETUP.RecentFiles.File2;
    SETUP.RecentFiles.Type3 = SETUP.RecentFiles.Type2;
    SETUP.RecentFiles.File2 = SETUP.RecentFiles.File1;
    SETUP.RecentFiles.Type2 = SETUP.RecentFiles.Type1;
    SETUP.RecentFiles.File1 = file;
    SETUP.RecentFiles.Type1 = type;
else
    temp    = SETUP.RecentFiles;
    rest    = setdiff([1:4],ind);
    for ii=3:-1:1;
        eval(['SETUP.RecentFiles.File' num2str(ii+1) '= temp.File' num2str(rest(ii)) ';']);
        eval(['SETUP.RecentFiles.Type' num2str(ii+1) '= temp.Type' num2str(rest(ii)) ';']);
    end
    SETUP.RecentFiles.File1 = eval(['temp.File' num2str(ind) ';']);
    SETUP.RecentFiles.Type1 = eval(['temp.Type' num2str(ind) ';']);
end

str = {'on','off'};
[p,fileTemp,e]  = fileparts(SETUP.RecentFiles.File1);
set(findobj(aniFig,'Tag','Menu:File:File1'),'Label',[fileTemp,e],'Visible',str{isempty(SETUP.RecentFiles.File1)+1});
[p,fileTemp,e]  = fileparts(SETUP.RecentFiles.File2);
set(findobj(aniFig,'Tag','Menu:File:File2'),'Label',[fileTemp,e],'Visible',str{isempty(SETUP.RecentFiles.File2)+1});
[p,fileTemp,e]  = fileparts(SETUP.RecentFiles.File3);
set(findobj(aniFig,'Tag','Menu:File:File3'),'Label',[fileTemp,e],'Visible',str{isempty(SETUP.RecentFiles.File3)+1});
[p,fileTemp,e]  = fileparts(SETUP.RecentFiles.File4);
set(findobj(aniFig,'Tag','Menu:File:File4'),'Label',[fileTemp,e],'Visible',str{isempty(SETUP.RecentFiles.File4)+1});

%==========================================================================
function clr = getColor(default,msg);
clr = uisetcolor(default,msg);
if ismember(clr,default,'rows')
    clr = [];
end

%==========================================================================
function updatePrefs(action,dlg,TEMP)
set(findobj(dlg,'Tag','Preferences:AutoApply'),'Value',TEMP.Animation.AutoApplyPrefs);
switch action
    case 'all'
        updatePrefs('animation' ,dlg,TEMP)
        updatePrefs('display'   ,dlg,TEMP)
        updatePrefs('view'      ,dlg,TEMP)
        updatePrefs('color'     ,dlg,TEMP)
        
    case 'animation'
        set(findobj(dlg,'Tag','Preferences:FPC'),'String',num2str(TEMP.Animation.Frames));
        set(findobj(dlg,'Tag','Preferences:Amp'),'String',num2str(TEMP.Animation.Amplitude));
        set(findobj(dlg,'Tag','Preferences:Deg'),'String',num2str(TEMP.Animation.Theta));
    case 'display'
        set(findobj(dlg,'Tag','Preferences:Annotate'),'Value',TEMP.Display.Annotate);
        set(findobj(dlg,'Tag','Preferences:Static')  ,'Value',TEMP.Display.Static);
        set(findobj(dlg,'Tag','Preferences:Markers') ,'Value',TEMP.Display.Markers);
        set(findobj(dlg,'Tag','Preferences:Labels')  ,'Value',TEMP.Display.Labels);
        set(findobj(dlg,'Tag','Preferences:UCS')     ,'Value',TEMP.Display.UCS);
        set(findobj(dlg,'Tag','Preferences:Spin')    ,'Value',TEMP.Display.Spin);
    case 'view'
        str = get(findobj(dlg,'Tag','Preferences:Axis'),'String');
        val = find(ismember(str,TEMP.View.Axis));
        set(findobj(dlg,'Tag','Preferences:Axis'),'Value',val);
        str = {'Single','Quad','Cross-eyed','Red/Blue Glasses'};
        val = find(ismember(str,TEMP.View.Type));
        set(findobj(dlg,'Tag','Preferences:Type'),'Value',val);
        str = get(findobj(dlg,'Tag','Preferences:UpVector'),'String');
        val = find(ismember(str,TEMP.View.UpVector));
        set(findobj(dlg,'Tag','Preferences:UpVector'),'Value',val);
        str = get(findobj(dlg,'Tag','Preferences:VectorType'),'String');
        val = find(ismember(str,TEMP.View.VectorType));
        set(findobj(dlg,'Tag','Preferences:VectorType'),'Value',val);
    case 'color'
        set(findobj(dlg,'Tag','Preferences:BackgroundColor') ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Background);
        set(findobj(dlg,'Tag','Preferences:AnnotateColor')   ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Annotate);
        set(findobj(dlg,'Tag','Preferences:StaticColor')     ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Static);
        set(findobj(dlg,'Tag','Preferences:MarkersColor')    ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Markers);
        set(findobj(dlg,'Tag','Preferences:LabelsColor')     ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Labels);
        set(findobj(dlg,'Tag','Preferences:ShapeColor')      ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.Shape);
        set(findobj(dlg,'Tag','Preferences:UCSColor')        ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.UCS);
        set(findobj(dlg,'Tag','Preferences:RightEyeColor')   ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.RightEye);
        set(findobj(dlg,'Tag','Preferences:LeftEyeColor')    ,'BackgroundColor',TEMP.Colors.Background,'ForegroundColor',TEMP.Colors.LeftEye);
end

%==========================================================================
function TEMP = getDefaults(TEMP);
TEMP.Version.Nr            = '1.02 beta';
TEMP.Version.Date          = '13-Aug-2005';

TEMP.Display.Annotate      = 1;
TEMP.Display.Static        = 1;
TEMP.Display.Markers       = 0;
TEMP.Display.Labels        = 0;
TEMP.Display.UCS           = 0;
TEMP.Display.Spin          = 0;
TEMP.Display.MaxDeflection = 0;
TEMP.Display.Renderer      = 'zbuffer';
TEMP.Display.Fill = 0;

TEMP.Component.Open        = 0;
TEMP.Component.Wireframe   = 1;
TEMP.Component.Name        = [];
TEMP.Component.Color       = [0 0 0];
TEMP.Component.Visible     = 1;
TEMP.Component.Fill        = 0;

TEMP.Animation.Frames           = 250;
TEMP.Animation.Amplitude        = .25;
TEMP.Animation.Theta            = 30;
TEMP.Animation.MaxFrame         = round(TEMP.Animation.Frames/2);
TEMP.Animation.AutoApplyPrefs   = 0;

TEMP.View.Type              = 'Single';
TEMP.View.Axis              = 'Ortho';
TEMP.View.CrosseyeAngle     = 3;
TEMP.View.VectorType        = 'Complex';
TEMP.View.UpVector          = '+Z';
TEMP.View.MaxDeflection     = 0;

TEMP.Colors.Background  = [ 1   1   1  ];
TEMP.Colors.Annotate    = [ 0   0   0  ];
TEMP.Colors.Static      = [ 1   0   0  ];
TEMP.Colors.Markers     = [ 0   0   0  ];
TEMP.Colors.Labels      = [ 0   0   0  ];
TEMP.Colors.Shape       = [ 0   0   0  ];
TEMP.Colors.UCS         = [ 0.1 0.1 1  ];
TEMP.Colors.RightEye    = [ 1   0   0  ];
TEMP.Colors.LeftEye     = [ 0   1   1  ];

TEMP.AVI.On                = 0;
TEMP.AVI.Start             = 0;
TEMP.AVI.Frame             = 0;
TEMP.AVI.Movie             = [];
TEMP.AVI.Format            = 'Cinepak';
TEMP.AVI.Quality           = 75;
TEMP.AVI.TimeLength        = 1;
TEMP.AVI.DoAllModes        = 0;

TEMP.Snapshot.Format       = 'EMF metafile';
TEMP.Snapshot.Resolution   = 100;
TEMP.Snapshot.Quality      = 75;
TEMP.Snapshot.DoAllModes   = 0;
TEMP.Snapshot.Renderer     = 'Z-buffer';

%==========================================================================
function updateAniFig(aniFig,SETUP,H)
% Display
str = {'off','on'};
set(findobj(aniFig,'Tag','Menu:Display:Annotate')   ,'Checked',str{SETUP.Display.Annotate+1});
set(findobj(aniFig,'Tag','Menu:Display:Static')     ,'Checked',str{SETUP.Display.Static+1});
set(findobj(aniFig,'Tag','Menu:Display:Markers')    ,'Checked',str{SETUP.Display.Markers+1});
set(findobj(aniFig,'Tag','Menu:Display:Labels')     ,'Checked',str{SETUP.Display.Labels+1});
set(findobj(aniFig,'Tag','Menu:Display:UCS')        ,'Checked',str{SETUP.Display.UCS+1});
set(findobj(aniFig,'Tag','Menu:Display:Spin')       ,'Checked',str{SETUP.Display.Spin+1});
% View-Axis
val = ismember({'X','Y','Z','Ortho'},SETUP.View.Axis);
set(findobj(aniFig,'Tag','Menu:View:X')     ,'Checked',str{val(1)+1});
set(findobj(aniFig,'Tag','Menu:View:Y')     ,'Checked',str{val(2)+1});
set(findobj(aniFig,'Tag','Menu:View:Z')     ,'Checked',str{val(3)+1});
set(findobj(aniFig,'Tag','Menu:View:Ortho') ,'Checked',str{val(4)+1});
% ContextMenu-Axis
set(findobj(aniFig,'Tag','ContextMenu\Axes\X')      ,'Checked',str{val(1)+1});
set(findobj(aniFig,'Tag','ContextMenu\Axes\Y')      ,'Checked',str{val(2)+1});
set(findobj(aniFig,'Tag','ContextMenu\Axes\Z')      ,'Checked',str{val(3)+1});
set(findobj(aniFig,'Tag','ContextMenu\Axes\Ortho')  ,'Checked',str{val(4)+1});
% View-Type
val = ismember({'Single','Quad','Cross-eyed','Red/Blue Glasses'},SETUP.View.Type);
set(findobj(aniFig,'Tag','Menu:View:Single')    ,'Checked',str{val(1)+1});
set(findobj(aniFig,'Tag','Menu:View:Quad')      ,'Checked',str{val(2)+1});
set(findobj(aniFig,'Tag','Menu:View:Crosseyed') ,'Checked',str{val(3)+1});
set(findobj(aniFig,'Tag','Menu:View:RedBlue')   ,'Checked',str{val(4)+1});
% View-UpVector
val = ismember({'"X','+Y','+Z'},SETUP.View.UpVector);
set(findobj(aniFig,'Tag','Menu:View:+X'),'Checked',str{val(1)+1});
set(findobj(aniFig,'Tag','Menu:View:+Y'),'Checked',str{val(2)+1});
set(findobj(aniFig,'Tag','Menu:View:+Z'),'Checked',str{val(3)+1});
% View-VectorType
val = ismember({'Real','Imaginary','Complex'},SETUP.View.VectorType);
set(findobj(aniFig,'Tag','Menu:View:Real')      ,'Checked',str{val(1)+1});
set(findobj(aniFig,'Tag','Menu:View:Imaginary') ,'Checked',str{val(2)+1});
set(findobj(aniFig,'Tag','Menu:View:Complex')   ,'Checked',str{val(3)+1});
% Edits&Sliders
set(findobj(aniFig,'Tag','Edit:FPC')    ,'String',num2str(SETUP.Animation.Frames));
set(findobj(aniFig,'Tag','Slider:FPC')  ,'Value' ,SETUP.Animation.Frames);
set(findobj(aniFig,'Tag','Edit:Amp')    ,'String',num2str(SETUP.Animation.Amplitude));
set(findobj(aniFig,'Tag','Slider:Amp')  ,'Value' ,SETUP.Animation.Amplitude);
set(findobj(aniFig,'Tag','Edit:Deg')    ,'String',num2str(SETUP.Animation.Theta));
set(findobj(aniFig,'Tag','Slider:Deg')  ,'Value' ,SETUP.Animation.Theta);

% Fig & Axes
bgc = SETUP.Colors.Background;
set(aniFig,'Color',bgc);
axs = findobj(aniFig,'Type','Axes');
set(findobj(aniFig,'Tag','Text:Annotate'),'ForegroundColor',SETUP.Colors.Annotate,'BackgroundColor',bgc)
for ii=1:length(axs)
    set(axs(ii),'Color',bgc,'Xcolor',bgc,'Ycolor',bgc,'Zcolor',bgc);
end
if ~isempty(H)
    % Colors -----------------
    if strcmp(SETUP.View.Type,'Red/Blue Glasses')
        clr = [SETUP.Colors.LeftEye;SETUP.Colors.RightEye];
        for ii=1:2
            set(H.Static(ii)    ,'Color',clr(ii,:))
            set(H.Markers(ii)   ,'Color',clr(ii,:))
            set(H.Labels(:,ii)  ,'Color',clr(ii,:))
            set(H.UCS(ii)       ,'Color',clr(ii,:))
            set(H.Conn(ii)      ,'Color',clr(ii,:))
        end
    else
        set(H.Static    ,'Color',SETUP.Colors.Static)
        set(H.Markers   ,'Color',SETUP.Colors.Markers)
        set(H.Labels    ,'Color',SETUP.Colors.Labels)
        set(H.UCS       ,'Color',SETUP.Colors.UCS)
        set(H.Conn      ,'Color',SETUP.Colors.Shape)
    end
    % Display
    command('Change','Annotate' ,SETUP.Display.Annotate,'skip')
    command('Change','Static'   ,SETUP.Display.Static,'skip')
    command('Change','Markers'  ,SETUP.Display.Markers,'skip')
    command('Change','Labels'   ,SETUP.Display.Labels,'skip')
    command('Change','UCS'      ,SETUP.Display.UCS,'skip')
    command('Change','Spin'     ,SETUP.Display.Spin,'skip')
    
    % View -------------------
    command('changeView'    ,SETUP.View.Axis,'skip');
    command('viewType'      ,SETUP.View.Type,'skip');
    command('MultipleChange',SETUP.View.UpVector,'skip')
    command('MultipleChange',SETUP.View.VectorType,'skip')
end

%==========================================================================
function str = compListbox(SETUP);
onStr   = {'off','on'};
for ii=1:size(SETUP.Component.Name)
    str{ii,1}   = sprintf('%-10s %3s %3s  [%0.2f %0.2f %0.2f]',SETUP.Component.Name{ii},...
        onStr{SETUP.Component.Visible(ii,1)+1},...
        onStr{SETUP.Component.Fill(ii,1)+1},...
        SETUP.Component.Color(ii,:));
end

%==========================================================================
function UFF = createUFF(GEOMETRY,MODAL,SETUP,UFF);
UFF = [];
% Header (151)
ii  = 1;
UFF.dsn151	= ii;
UFF.DATA{ii,1}.DSN    = 151;
UFF.DATA{ii,1}.UID    = [];
UFF.DATA{ii,1}.Ext    = [];
UFF.DATA{ii,1}.ModelFileName         = SETUP.Path.ModalFile;
UFF.DATA{ii,1}.ModelFileDescription  = 'Modal Vector Animation';
UFF.DATA{ii,1}.ProgramDB     = 'Modal Vector Animation';
UFF.DATA{ii,1}.DateCreated   = datestr(now,1);
UFF.DATA{ii,1}.TimeCreated   = datestr(now,13);
UFF.DATA{ii,1}.Version1      = 0;
UFF.DATA{ii,1}.Version2      = 0;
UFF.DATA{ii,1}.FileType      = 0;
UFF.DATA{ii,1}.DateSaved     = datestr(now,1);
UFF.DATA{ii,1}.TimeSaved     = datestr(now,13);
UFF.DATA{ii,1}.ProgramUF     = 'Modal Vector Animation';
UFF.DATA{ii,1}.DateWritten   = datestr(now,1);
UFF.DATA{ii,1}.TimeWritten   = datestr(now,13);
% Units (164)
ii  = 2;
UFF.dsn164	= ii;
UFF.DATA{ii,1}.DSN               = 164;
UFF.DATA{ii,1}.UID               = [];
UFF.DATA{ii,1}.Ext               = [];
UFF.DATA{ii,1}.UnitsCode         = 9;
UFF.DATA{ii,1}.UnitsDescription  = 'User Defined';
UFF.DATA{ii,1}.TempMode          = 0;
UFF.DATA{ii,1}.Length            = 1;
UFF.DATA{ii,1}.Force             = 1;
UFF.DATA{ii,1}.Temperature       = 1;
UFF.DATA{ii,1}.TemperatureOffset = 0;

% Nodes (15)
ii  = 3;
UFF.dsn15 	= ii;
UFF.DATA{ii,1}.DSN    = 15;
UFF.DATA{ii,1}.UID    = [];
UFF.DATA{ii,1}.Ext    = [];
for jj=1:length(GEOMETRY.node)
    UFF.DATA{ii,1}.Node(jj,1).Label  = GEOMETRY.node(jj);
    UFF.DATA{ii,1}.Node(jj,1).defCS  = 0;
    UFF.DATA{ii,1}.Node(jj,1).dispCS = 0;
    UFF.DATA{ii,1}.Node(jj,1).Color  = 1;
    UFF.DATA{ii,1}.Node(jj,1).Crd    = [GEOMETRY.x(jj) GEOMETRY.y(jj) GEOMETRY.z(jj)];
end

% Wireframe (82)
ii  = 4;
UFF.dsn82 	= ii;
UFF.DATA{ii,1}.DSN           = 82;
UFF.DATA{ii,1}.UID           = [];
UFF.DATA{ii,1}.Ext           = [];
UFF.DATA{ii,1}.ID            = 'None';
UFF.DATA{ii,1}.TraceNum      = 1;
UFF.DATA{ii,1}.Color         = 1;
conn                    = GEOMETRY.conn;
conn(find(isnan(conn))) = 0;
conn(find(conn<0))      = 0;
UFF.DATA{ii,1}.Trace         = conn;

% Modes (55)
%MODAL=MODAL(1:7);   % Outcommented 2011-11-03, occasional crash
for modeNr = 1:length(MODAL)
    ii  = 4+modeNr;
    UFF.DATA{ii,1}.DSN    = 55;
    UFF.DATA{ii,1}.UID    = [];
    UFF.DATA{ii,1}.Ext    = [];
    % 2012-01-13: enhancement: Add freq & damping to ID Line 1 for 
    % Engineering Office display
    UFF.DATA{ii,1}.ID{1,1}=['Freq ' num2str(imag(MODAL(modeNr).Freq)) ', Damp ' num2str(real(MODAL(modeNr).Freq))];
    for jj=2:5;
        UFF.DATA{ii,1}.ID{jj,1}  = 'None';
    end
    UFF.DATA{ii,1}.modelType     = 1;
    UFF.DATA{ii,1}.analysisType  = 3;
    UFF.DATA{ii,1}.dataChar      = 2;
    UFF.DATA{ii,1}.specificType  = 8;
    UFF.DATA{ii,1}.Int           = [1 modeNr];
    UFF.DATA{ii,1}.Real          = [real(MODAL(modeNr).Freq) imag(MODAL(modeNr).Freq) 0 0 0 0]*2*pi;
    for node = 1:size(MODAL(1).Nodes,1)
        UFF.DATA{ii,1}.Node(node,1).Num  = MODAL(modeNr).Nodes(node);
        UFF.DATA{ii,1}.Node(node,1).Data = MODAL(modeNr).Data(node,:);
    end
end
UFF.dsn55   = [5:length(UFF.DATA)].';