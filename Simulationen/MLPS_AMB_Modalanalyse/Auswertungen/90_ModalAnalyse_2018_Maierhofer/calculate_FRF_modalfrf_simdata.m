% Berechne Frequenzgangfunktion der Messung
% zunächst nur bei einer bestimmten Drehzahl
% mithilfe der Matlab-Funktion modalfrf

clear

% Datei laden
load('0rpm_0-200Hz_rpm0.mat')
% load('testSimJust1AMB_rpm1000.mat')
time = data.time;


% Parameter fuer FRF setzen
Ts = (time(end)-time(1)) / length(time);
fs = 1/Ts;
windowLength = length(time);%
% windowLength =round(length(time)/4);
numberOverlap = round(windowLength/2);

%% Einlesen der Werte und filtern
fPass = 10;

% force(:,1) = data.x_dir_Kraft_ML1_;
% force(:,2) = data.y_dir_Kraft_ML1_;
% force(:,3) = data.x_dir_Kraft_Lager1_;
% force(:,4) = data.y_dir_Kraft_Lager1_;
force(:,1) = data.x_dir_KraftLager2_;

force(isnan(force)) = 0;

for k = size(force,2)
%     force(:,k) = highpass(force(:,k),fPass,fs);
    force(:,k) = force(:,k) - mean(force(:,k)); %Mittelung, da Offset der Messung
end

% force = force(1:end/2,:);

% displacement(:,1) = data.x_dir_Weg_ML1_;
% displacement(:,2) = data.y_dir_Weg_ML1_;
% displacement(:,3) = data.x_dir_Weg_Lager1_;
% displacement(:,4) = data.y_dir_Weg_Lager1_;
displacement(:,1) = data.x_dir_WegLager1_;
displacement(:,2) = data.x_dir_WegScheibe_;
displacement(:,3) = data.x_dir_WegLager2_;

displacement(isnan(displacement)) = 0;

for k = 1:size(displacement,2)
%     displacement(:,k) = highpass(displacement(:,k),fPass,fs);
    displacement(:,k) = displacement(:,k) - mean(displacement(:,k)); %Mittelung, da Offset der Messung
end

% displacement = displacement(1:end/2,:);

%% modalfrf
% [frf,f,coh] = modalfrf(displacement,force,fs,windowLength);
[frf,f,coh] = modalfrf(force,displacement,fs,windowLength,numberOverlap,'Sensor','dis');

%% modalfrf plot
figFRF = figure;
modalfrf(force,displacement,fs,windowLength,numberOverlap,'Sensor','dis');
% modalfrf(displacement,force,fs,windowLength);
axH = findall(figFRF,'type','axes');
% set(axH,'xlim',[0 1]*200)

% Identifiziere Eigenfrequezen und Daempfungen
[fn,dr] = modalfit(frf,f,fs,1,'FitMethod','PP')
[fn,dr,ms,ofrf] = modalfit(frf,f,fs,1,'FitMethod','PP');
figure
for k = 1:size(displacement,2)
    subplot(size(displacement,2),1,k)
    semilogy(f,abs(frf(:,k)),f,abs(ofrf(:,k)))
    legend('frf','ofrf')
end
