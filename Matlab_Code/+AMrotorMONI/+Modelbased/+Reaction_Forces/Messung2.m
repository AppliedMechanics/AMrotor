function data = Messung2()

mlib('SelectBoard','ds1103');

disp('Recording of measurement...')
Sensor1_Name='Model Root/Pos_Welle_x/In1';
[Sensor1_Adr]=mlib('GetTrcVar',Sensor1_Name);

Sensor2_Name='Model Root/Pos_Welle_y/In1';
[Sensor2_Adr]=mlib('GetTrcVar',Sensor2_Name);

Sensor3_Name='Model Root/Drehzahl_Tacho1/In1';
[Sensor3_Adr]=mlib('GetTrcVar',Sensor3_Name);

Sensor4_Name='Model Root/Winkel/In1';
[Sensor4_Adr]=mlib('GetTrcVar',Sensor4_Name);

Sensor5_Name='Model Root/Pos_Welle_w18_korr/In1';
[Sensor5_Adr]=mlib('GetTrcVar',Sensor5_Name);

Sensor6_Name='Model Root/Kraft_GL_1/In1';
[Sensor6_Adr]=mlib('GetTrcVar',Sensor6_Name);

Sensor7_Name='Model Root/Kraft_GL_2/In1';
[Sensor7_Adr]=mlib('GetTrcVar',Sensor7_Name);

Sensor8_Name='Model Root/Kraft_WL_1/In1';
[Sensor8_Adr]=mlib('GetTrcVar',Sensor8_Name);

Sensor9_Name='Model Root/Kraft_WL_2/In1';
[Sensor9_Adr]=mlib('GetTrcVar',Sensor9_Name);

DownSample = 10;

Samples = 10000;

%% data aquisition parameters
mlib('Set',...
    'Trigger','ON',...
    'TriggerVariable', Sensor4_Adr, ...
    'TriggerLevel',180,...
    'TriggerEdge','rising',...
    'Downsampling',DownSample,...
    'TimeStamping','ON',...
    'Delay',0,...
    'NumSamples', Samples,...
    'TraceVars',[Sensor1_Adr; Sensor2_Adr; Sensor3_Adr; Sensor4_Adr; Sensor5_Adr; Sensor6_Adr; Sensor7_Adr; Sensor8_Adr; Sensor9_Adr]);  %hier alle aufzuzeichnenden sachen eintragen


% capture values
mlib('StartCapture');

while mlib('CaptureState')~=0
    pause(1);
end

% read values
data = mlib('FetchData');
if std(data(4,:))*10 > abs(mean(data(4,:)))
    clear data
    disp(' ')
    disp('Drehzahl war instationaer. Messung wird wiederholt...')
    data = Messung();
    disp(' ')
end


