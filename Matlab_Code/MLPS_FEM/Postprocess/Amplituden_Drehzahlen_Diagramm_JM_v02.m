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
n_Laval = 18.3*60;

%% Plot Durchsenkung über Drehzahl

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n))/n_Laval;

     a(i_n) = mean(abs(data(6,:,i_n)));

end

for i_n=1:size(data,3)
    
     n(i_n) = mean(data(12,:,i_n))/n_Laval;

     a2(i_n) = mean(abs(data(2,:,i_n)));

end

a_n = [n',a'];
[a_max, idx] = max(a_n(:,2));
n_max = n(idx);

figure;
plot(n,a);
hold on;
plot(n,a2)
%plot([n_max,n_max],[0,a_max],'g');
xlabel('Bezogene Drehzahl');
ylabel('Amplitude |w|');
title('Durchsenkung über Drehzahl an der Scheibe x-Richtung');
grid on;
%legend({'Amplitude Scheibe x-Richtung',['Peak: ' num2str(n_max*n_Laval) 'U/min = ' num2str(n_max*n_Laval/60) 'Hz']});
legend({'Amplitude Scheibe','Amplitude Lager'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../../01_Simulation/Matlab2Tikz');
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
