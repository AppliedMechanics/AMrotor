% Datenaufbreitung

DataSetAlt = containers.Map('KeyType','double','ValueType','any');
w=[200:100:400];
for P=1:3
    DataSetAlt(w(P))=containers.Map;
    
    K=num2str(w(P));
    data=(['.\data',K, '.mat' ]);

    load(data)
tmp = DataSetAlt(w(P));
tmp('time') = data(1,:);
tmp('s_x (Positionssensor Scheibe)') = data(2,:);
tmp('s_y (Positionssensor Scheibe)') = data(3,:);
tmp('n') = data(4,:);
tmp('Phi') = data(5,:)*pi/180;
tmp('s_xymisch (Positionssensor Scheibe)') = data(6,:);
tmp('F_x (Kraftsensor links)') = data(7,:);
tmp('F_y (Kraftsensor links)') = data(8,:);
tmp('F_x (Kraftsensor rechts)') = data(9,:);
tmp('F_y (Kraftsensor rechts)') = data(10,:);
end
DataSetNeu = containers.Map('KeyType','double','ValueType','any');
w=[1800:100:2000];
for P=1:3
    DataSetNeu(w(P))=containers.Map;
    
    K=num2str(w(P));
    data=(['.\data',K, '.mat' ]);

    load(data)
tmp = DataSetNeu(w(P));
tmp('time') = data(1,:);
tmp('s_x (Positionssensor Scheibe)') = data(2,:);
tmp('s_y (Positionssensor Scheibe)') = data(3,:);
tmp('n') = data(4,:);
tmp('Phi') = data(5,:)*pi/180;
tmp('s_xymisch (Positionssensor)') = data(6,:);
tmp('F_x (Kraftsensor links)') = data(7,:);
tmp('F_y (Kraftsensor links)') = data(8,:);
tmp('F_x (Kraftsensor rechts)') = data(9,:);
tmp('F_y (Kraftsensor rechts)') = data(10,:);
end

% for z=1:size(name,2)
%     speicherbarerNameOhneMat=name{z}(1,1:end-4);
%     figure('name',speicherbarerNameOhneMat);
%     DateipfadName=(['D:\Simulation_RH_v01\',name{z},]);
%     load(DateipfadName);
%     temp=dataset_monitoring;
%     schluessel=keys(temp);
%         for K=1:12   % Anzahl Simulationsparameter
%             subplot(4,3,K);
%                 for y=3:size(schluessel,2)
%                     local=dataset_monitoring(schluessel{y});
%                     localkey=keys(local);
%                     Vektor=[1,10,12,3,11,7,2,8,5,4,9,6];
%                     localkeysorted=localkey(Vektor);
%                     meinSet(K,:)=local(localkeysorted{K});
%                     hold on;
%                     plot(meinSet(K,:));
%                     title(localkeysorted{K});
%                 end
%             hold off;
%         end
% end
save DataSetAlt
save DataSetNeu