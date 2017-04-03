%% BESCHREIBUNG %%

%Skript erstellt Wasserfalldiagramm aus einem Datensatz "data"

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

%%
 clc
% close all

%%
% Initailisierung

if mod(size(data,2),2)
    data(:,end,:)=[];
end

f = zeros (size(data,3),size(data,2)/2+1);
y_norm = zeros (size(data,3),size(data,2)/2+1);
n = zeros(size(data,3),size(data,2)/2+1);

% Durchführen FFT für alle Drehzahlen
for i=1:size(data,3)

    [f(i,:),y_norm(i,:)] = MLPS_FFT_v02(data(4,:,i),data(1,:,i));
    
end

% Bestimmung der Drehzahlen
for i = 1:size(data,3)
    
    n(i,:) = mean(data(12,:,i));
    
end

%% Plot Fourierreihe
% figure;
% plot(y_norm(1,:));
% legende{1}=num2str(n(1));
% title (['Spektrum - Sensor Scheibe']);
% xlabel('Frequenz in Hz');
% ylabel('Amplitude');
% grid on;
% hold on;
% for j = 2:size(f,1)
%     plot(y_norm(j,:));
%     legende{j}=num2str(n(j));
% end
% legend(legende, 'show');




%% Plot
fig = figure;

mesh(n(:,2:200),f(:,2:200),y_norm(:,2:200))
set(fig, 'Units', 'normalized', 'Position', [0.2, 0.2, 0.7, 0.7]);
%caxis([0 0.01]) 
%zlim([0,0.06])
%ylim([0,200]);
set(gca,'YDir','Reverse')
view(-120,40)
grid on

title('Wasserfalldiagramm: Magnetlager 2 x-Richtung','FontSize',20)
xlabel('Drehzahl in Umin','FontSize',16)
ylabel('Frequenz in Hz','Fontsize',16)
zlabel('Amplitude in mm','FontSize',16)



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




