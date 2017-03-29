%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLPS
% Stelle Frequenzgänge der Magnetlagerströme dar.
%
% Johannes Maierhofer
% 20.06.2016
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
    
     [f(1,:,i_n),y_norm(1,:,i_n)] = MLPS_FFT_v02(data(8,:,i_n),data(1,:,i_n));
     [f(2,:,i_n),y_norm(2,:,i_n)] = MLPS_FFT_v02(data(9,:,i_n),data(1,:,i_n));
     [f(3,:,i_n),y_norm(3,:,i_n)] = MLPS_FFT_v02(data(10,:,i_n),data(1,:,i_n));
     [f(4,:,i_n),y_norm(4,:,i_n)] = MLPS_FFT_v02(data(11,:,i_n),data(1,:,i_n));
     
     for k=1:4
         [y_norm_max(k,i_n), idx] = max(y_norm(k,:,i_n));
         [f_max(k,i_n)] = ind2sub(1, idx);
     end
     
    figure;
    legende={'Lager 1: x-Richtung','Lager 1: y-Richtung','Lager 2: x-Richtung','Lager 2: y-Richtung'};
    Lagerstelle = {'1','1','2','2'};
    Richtung = {'x','y','x','y'};
    for j = 1:4
    subplot(2,2,j);
    plot(y_norm(j,:,i_n));
    ylim=[0,max(y_norm(1,:,i_n))];
    hold all;
    plot([n(i_n)/60,n(i_n)/60],[ylim(1),ylim(2)],'r--');
    plot([2*n(i_n)/60,2*n(i_n)/60],[ylim(1),ylim(2)],'r--');
    plot([3*n(i_n)/60,3*n(i_n)/60],[ylim(1),ylim(2)],'r--');
    plot([f_max(j,i_n),f_max(j,i_n)],[0,y_norm_max(j,i_n)],'g');
    title (['Lagerstelle: ' Lagerstelle{j} '  -  Richtung: ' Richtung{j}]);
    xlabel('Frequenz in Hz');
    ylabel('Amplitude');
    grid on;
    legend({legende{j},['1.EO ' num2str(n(i_n)/60) 'Hz'],['2.EO ' num2str(2*n(i_n)/60) 'Hz'],['3.EO ' num2str(2*n(i_n)/60) 'Hz'],['Peak: ' num2str(f_max(j,i_n)) ' Hz']});
    end
    suptitle(['Magnetlager Strom FFT - Drehzahl: ' num2str(n(i_n)) 'U/min']);
    
end