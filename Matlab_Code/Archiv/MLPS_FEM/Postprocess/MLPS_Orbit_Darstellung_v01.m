%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLPS
% Stelle Orbits aus Messdaten dar
%
% Johannes Maierhofer
% 29.06.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *Datenstruktur*
%
% data(i,j,k) --> i Sensor, j Zeilen der Messwerte, k Drehzahl
%
% data(1)  = [s] Zeit
% data(2)  = [m] Wirbelstromsensor_z1 (Global Lager1:  x - Richtung)
% data(3)  = [m] Wirbelstromsensor_y1 (Global Lager1:  Y - Richtung)
% data(4)  = [m] Wirbelstromsensor_z2 (Global Lager2:  x - Richtung)
% data(5)  = [m] Wirbelstromsensor_y2 (Global Lager2:  Y - Richtung)
% data(6)  = [m] Lasersensor_z (Global Scheibe:  x - Richtung)
% data(7)  = [m] Lasersensor_y (Global Scheibe:  Y - Richtung)
% data(8)  = [A] Magnetlagerstrom_z1 (Global Lager1:  x - Richtung)
% data(9)  = [A] Magnetlagerstrom_y1 (Global Lager1:  y - Richtung)
% data(10)  = [A] Magnetlagerstrom_z2 (Global Lager1:  x - Richtung)
% data(11)  = [A] Magnetlagerstrom_y2 (Global Lager1:  y - Richtung)
% data(12)  = [U/min] Drezahl aus Inkrementalgeber
% data(13)  = [grad] Winkel aus Inkrementalgeber
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean up

clc;
%close all;

%% Drehzahlen plotten
% figure;
% 
% for i_n=1:size(data,3)
% 
% plot(data(1,:,i_n),data(12,:,i_n));
% hold on;
% 
% end
% 
% title('Drehzahlen über die Zeit');

%% Ergebnis darstellen (früher in der main) - ungefilterte Zeitdarstellung

 w = [0:1e-2:2*pi];
 r1 = (1.4/2)*1e-3; %m Radius des Fanglager - Radius der Welle
 r2 = (1.4/2)*1e-3; %m Radius des Fanglager
 rS = (8/2)*1e-3; %m Radius des Fanglager an der Scheibe - Radius des Läufers
Fanglager_1=[r1*sin(w); r1*sin(w+pi/2)];
 Fanglager_2=[r2*sin(w); r2*sin(w+pi/2)];
 Fanglager_S=[rS*sin(w); rS*sin(w+pi/2)];
%     
% for i=1:size(data,3)
%     
%     n(i) = mean(data(12,:,i));
%     
%     figure;
%     subplot(3,3,1);
%     plot(data(1,:,i),data(2,:,i));
%     title('Lager 1 x-Richtung');
%     
%     subplot(3,3,2);
%     plot(data(1,:,i), data(6,:,i));
%     title('Scheibe x-Richtung');
%     
%     subplot(3,3,3);
%     plot(data(1,:,i),data(4,:,i));
%     title('Lager 2 x-Richtung');
%     
%     subplot(3,3,4);
%     plot(data(1,:,i),data(3,:,i));
%     title('y-Richtung');
%     
%     subplot(3,3,5);
%     plot(data(1,:,i), data(7,:,i));
%     title('y-Richtung');
%     
%     subplot(3,3,6);
%     plot(data(1,:,i),data(5,:,i));
%     title('y-Richtung');
%     
%     subplot(3,3,7);
%     plot(data(2,:,i),data(3,:,i));
%     hold on;
%     plot(Fanglager_1(1,:),Fanglager_1(2,:),'--r');
%     title('Orbit');
%     axis equal;
%     
%     subplot(3,3,8);
%     plot(data(6,:,i),data(7,:,i));
%     hold on;
%     plot(Fanglager_S(1,:),Fanglager_S(2,:),'--r');
%     title('Orbit');
%     axis equal;
%     
%     subplot(3,3,9);
%     plot(data(4,:,i),data(5,:,i));
%     hold on;
%     plot(Fanglager_2(1,:),Fanglager_2(2,:),'--r');
%     title('Orbit');
%     axis equal;
%     
%     suptitle(['Drehzahl: ',num2str(n(i)), 'U/min']);
% end

% Orbitschriebe mit Fourierfit

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n));
     
    for i=1:11
        data_fit(i,:,i_n) = MLPS_FourierFit1_v02(data(1,:,i_n),data(i,:,i_n),n(i_n));
        %data_fit(i,:,i_n) = MLPS_SineSum_Fit8_v01(data(1,:,i_n),data(i,:,i_n));
    end
    
    %Tiefpassfilterung 
    fs=1000;
    f_tp=3*n(i_n)/60;
[b, a] = butter(5,f_tp/(0.5*fs),'low'); % Koeffizienten der Übertragungsfunktion, f_tp ist die Grenzfrequenz, fs die Abtastfrequ., Butterworthfilter 

    for i=1:11
        data_filter(i,:,i_n) = filter(b,a,data(i,:,i_n));
    end
    
    figure;
    subplot(2,3,1);
    plot(data(2,:,i_n),data(3,:,i_n));
    hold on;
    %plot(data_filter(2,:,i_n),data_filter(3,:,i_n));
    plot(Fanglager_1(1,:),Fanglager_1(2,:),'--r');
    plot(data_fit(2,:,i_n),data_fit(3,:,i_n));
    title('Lager-1 global');
    axis equal;
    
    subplot(2,3,2);
    plot(data(6,:,i_n),data(7,:,i_n));
    hold on;
    %plot(data_filter(6,:,i_n),data_filter(7,:,i_n));
    plot(Fanglager_S(1,:),Fanglager_S(2,:),'--r');
    plot(data_fit(6,:,i_n),data_fit(7,:,i_n));    
    title('Scheibe');
    axis equal;
    
    subplot(2,3,3);
    plot(data(4,:,i_n),data(5,:,i_n));
    hold on;
    %plot(data_filter(4,:,i_n),data_filter(5,:,i_n));
    plot(Fanglager_2(1,:),Fanglager_2(2,:),'--r');
    plot(data_fit(4,:,i_n),data_fit(5,:,i_n));
    title('Lager-2 global');
    axis equal;
    
    subplot(2,3,4);
    plot(data(2,:,i_n));
    hold on;
    plot(data(3,:,i_n));
    
        subplot(2,3,5);
    plot(data(6,:,i_n));
    hold on;
    plot(data(7,:,i_n));
    
        subplot(2,3,6);
    plot(data(4,:,i_n));
    hold on;
    plot(data(5,:,i_n));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../Matlab2Tikz');
% help matlab2tikz

Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
[fpathstr,fname,fext] = fileparts(which(mfilename));

%cleanfigure;
matlab2tikz('tikzFileComment',['%%% Johannes Maierhofer -', Datum, ' %%%'],'height','\fheight','width','\fwidth','filename',[fname, '__', Datum, '.tikz']);

h = gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf',[fname, '__' ,Datum, '.pdf']); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 

