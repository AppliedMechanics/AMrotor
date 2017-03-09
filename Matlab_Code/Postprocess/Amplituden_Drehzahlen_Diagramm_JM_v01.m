%% *Plot der Amplituden der Auslenkungen über die Drehzahlen*
%
% Johannes Maierhofer
% Angewandte Mechanik TUM
% 23.06.2016
%
% Version 01
% 
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

%close all;
clc;

%% Plot Durchsenkung über Drehzahl

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n));

     a(i_n) = mean(abs(data(6,:,i_n)));

end

a_n = [n',a'];
[a_max, idx] = max(a_n(:,2));
n_max = n(idx);

figure;
plot(n,a);
hold on;
plot([n_max,n_max],[0,a_max],'g');
xlabel('Drehzahlen');
ylabel('Amplitude |w|');
title('Durchsenkung über Drehzahl an der Scheibe x-Richtung');
grid on;
legend({'Amplitude Scheibe x-Richtung',['Peak: ' num2str(n_max) 'U/min = ' num2str(n_max/60) 'Hz']});