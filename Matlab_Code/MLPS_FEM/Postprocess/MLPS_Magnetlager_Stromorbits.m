%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLPS
% Stelle Orbits des Magnetlagerstrom dar
%
% Johannes Maierhofer
% 08.06.2016
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
close all;

%% Rohdaten

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n));
    
    figure;
    
    subplot(2,2,1);
    plot(data(8,:,i_n));
    hold on;
    plot(data(9,:,i_n));
    title(['Drehzahl: ' num2str(n(i_n)) ' U/min' ]);
    
    subplot(2,2,2);
    plot(data(10,:,i_n));
    hold on;
    plot(data(11,:,i_n));
    
    subplot(2,2,3);
    plot(data(8,:,i_n),data(9,:,i_n));
        xlim([-7,7]);
    axis equal;
    grid on;
    title('Lager-1 global');
    
    subplot(2,2,4);
    plot(data(10,:,i_n),data(11,:,i_n));
        xlim([-7,7]);
    axis equal;
    grid on;
    title('Lager-2 global');
    
end

%% Datenfit

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n));
     
    for i=8:11
        data_fit(i,:,i_n) = MLPS_FourierFit1_v02(data(1,:,i_n),data(i,:,i_n),n(i_n));
    end
    
    figure;
    
    subplot(2,2,1);
    plot(data_fit(8,:,i_n));
    hold on;
    plot(data_fit(9,:,i_n));
    
    subplot(2,2,2);
    plot(data_fit(10,:,i_n));
    hold on;
    plot(data_fit(11,:,i_n));
    
    subplot(2,2,3);
    plot(data_fit(8,:,i_n),data_fit(9,:,i_n));
    title('Lager-1 global');
    
    subplot(2,2,4);
    plot(data_fit(10,:,i_n),data_fit(11,:,i_n));
    title('Lager-2 global');
    
end