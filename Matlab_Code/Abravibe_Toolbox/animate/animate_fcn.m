function retVal = animate_fcn;

global UDATA SETUP
aniFig=findobj(0,'TAG','ANIMATE');

aniAxis=findobj(aniFig,'Tag','Axes:Single');
retVal  =  get(findobj(aniFig,'Tag','Toggle:Animate'),'Value');

NUDATA  = get(aniAxis,'Userdata');
ANI     = NUDATA.ANI;
%Nodes   = NUDATA.NODES;

UDATA.ActiveFrame   = UDATA.ActiveFrame+1;
if UDATA.ActiveFrame==UDATA.Frames+1;
    UDATA.ActiveFrame=1;
end

set(UDATA.Handles.Conn,'XData',ANI(1,UDATA.ActiveFrame).X,'YData',ANI(1,UDATA.ActiveFrame).Y,'ZData',ANI(1,UDATA.ActiveFrame).Z);

% animate the data point
set(UDATA.Handles.Markers,'XData',NUDATA.NODES(:,1,UDATA.ActiveFrame),...
    'YData',NUDATA.NODES(:,2,UDATA.ActiveFrame),...
    'ZData',NUDATA.NODES(:,3,UDATA.ActiveFrame));

% animate text
for ii=1:length(UDATA.Handles.Labels)
    set(UDATA.Handles.Labels(ii,:),'Position',NUDATA.NODES(ii,:,UDATA.ActiveFrame));
end

% animate component
if SETUP.Component.Open
    for comp=1:size(SETUP.Component.Name,1)
        set(UDATA.Handles.Wire(comp,:),'XData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},1,UDATA.ActiveFrame),...
            'YData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},2,UDATA.ActiveFrame),...
            'ZData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},3,UDATA.ActiveFrame));
        set(UDATA.Handles.Mark(comp,:),'XData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},1,UDATA.ActiveFrame),...
            'YData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},2,UDATA.ActiveFrame),...
            'ZData',NUDATA.CompNodes(SETUP.Component.WireIndex{comp},3,UDATA.ActiveFrame));
        ind     = find(SETUP.Component.FillComps==comp);
        for ii=1:length(ind)
            %keyboard
            set(UDATA.Handles.Fill(ind(ii),:),'XData',NUDATA.NODES(SETUP.Component.FillConn{ind(ii)},1,UDATA.ActiveFrame),...
                'YData',NUDATA.NODES(SETUP.Component.FillConn{ind(ii)},2,UDATA.ActiveFrame),...
                'ZData',NUDATA.NODES(SETUP.Component.FillConn{ind(ii)},3,UDATA.ActiveFrame));
        end
    end
end


% Spin Axis
if SETUP.Display.Spin;
    camorbit(aniAxis,SETUP.Animation.Theta/UDATA.Frames,0,'camera',SETUP.View.UpVector(2))
    switch SETUP.View.Type,
        case 'Red/Blue Glasses'
            command('updateRotate')
        case 'Cross-eyed'
            camorbit(findobj(aniFig,'Tag','Axes:Ortho11'),SETUP.Animation.Theta/UDATA.Frames,0,'camera',SETUP.View.UpVector(2))
    end
end

drawnow;
if SETUP.Display.MaxDeflection & UDATA.ActiveFrame==SETUP.Animation.MaxFrame;
    set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
    retVal  = 0;
end


% Make AVI File
if SETUP.AVI.On & SETUP.Display.MaxDeflection==0;
    if SETUP.AVI.On==1 & (UDATA.ActiveFrame==1 | SETUP.AVI.Start==1);
        if UDATA.ActiveFrame==1 & SETUP.AVI.Start==0;
            SETUP.AVI.Start = 1;
            warning off
            SETUP.AVI.Object= avifile(SETUP.AVI.FileName,'fps',round(SETUP.Animation.Frames/SETUP.AVI.TimeLength),'quality',SETUP.AVI.Quality,'compression',SETUP.AVI.Format);
            warning on
        end
        SETUP.AVI.Frame     =SETUP.AVI.Frame+1;
        SETUP.AVI.Object    =addframe(SETUP.AVI.Object,getframe(gcf));
        if SETUP.AVI.Frame>3 & UDATA.ActiveFrame==1;
            SETUP.AVI.On=0;
            SETUP.AVI.Start=0;
            SETUP.AVI.Frame=0;
            SETUP.AVI.Object = close(SETUP.AVI.Object);
            SETUP.AVI.Object = [];
            if SETUP.AVI.DoAllModes
                set(findobj(aniFig,'Tag','Toggle:Animate'),'Value',0);
                retVal  = 0;
            end
        end
    end
end