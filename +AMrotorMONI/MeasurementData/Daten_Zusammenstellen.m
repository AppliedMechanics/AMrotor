% Datenaufbreitung

DataSetAlt = containers.Map('KeyType','double','ValueType','any');
w=[200:100:400];
for P=1:3
    DataSetAlt(w(P))=containers.Map;
    
    K=num2str(w(P));
    data=(['.\+AMrotorMONI\MeasurementData\data',K, '.mat' ]);

    load(data)
tmp = DataSetAlt(w(P));
tmp('time') = data(1,:);
tmp('s_x (Positionssensor)') = data(2,:);
tmp('s_y (Positionssensor)') = data(3,:);
tmp('omega') = data(4,:);
tmp('phi') = data(5,:);
tmp('s_xymisch (Positionssensor)') = data(6,:);
tmp('F_x (Lager 1)') = data(7,:);
tmp('F_y (Lager 1)') = data(8,:);
tmp('F_x (Lager 2)') = data(9,:);
tmp('F_y (Lager 2)') = data(10,:);
end
DataSetNeu = containers.Map('KeyType','double','ValueType','any');
w=[1800:100:2000];
for P=1:3
    DataSetNeu(w(P))=containers.Map;
    
    K=num2str(w(P));
    data=(['.\+AMrotorMONI\MeasurementData\data',K, '.mat' ]);

    load(data)
tmp = DataSetNeu(w(P));
tmp('time') = data(1,:);
tmp('s_x (Positionssensor)') = data(2,:);
tmp('s_y (Positionssensor)') = data(3,:);
tmp('omega') = data(4,:);
tmp('phi') = data(5,:);
tmp('s_xymisch (Positionssensor)') = data(6,:);
tmp('F_x (Lager 1)') = data(7,:);
tmp('F_y (Lager 1)') = data(8,:);
tmp('F_x (Lager 2)') = data(9,:);
tmp('F_y (Lager 2)') = data(10,:);
end