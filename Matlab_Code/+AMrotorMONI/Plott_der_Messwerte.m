close all
clear all
clc
% Alle Namen der Simulationsreihen erhalten
liste=dir('D:\Simulation_RH_v01\*.mat');
name= {liste.name};
for z=1:size(name,2)
    figure('name',name{z});
    DateipfadName=(['D:\Simulation_RH_v01\',name{z},]);
    load(DateipfadName);
    temp=dataset_monitoring;
    schluessel=keys(temp);
        for K=1:12   % Anzahl Simulationsparameter
            subplot(4,3,K);
                for y=3:size(schluessel,2)
                    local=dataset_monitoring(schluessel{y});
                    localkey=keys(local);
                    Vektor=[1,10,12,3,11,7,2,8,5,4,9,6];
                    localkeysorted=localkey(Vektor);
                    meinSet(K,:)=local(localkeysorted{K});
                    hold on;
                    plot(meinSet(K,:));
                    title(localkeysorted{K});
                end
            hold off;
        end
end