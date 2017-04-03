%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLPS
% Berechne die Kraft des Magnetlagers auf den Rotor in jedem Zeitschritt
%
% Johannes Maierhofer
% 08.06.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
close all;

%% Parameter aus Identifikation oder Datenblatt

k_ui = 0.8; %A/V, aus Datenblatt f�r Messverst�rker


k_i = 150; %N/A, aus Absch�tzung von Insam
k_s = 300; %N/mm, aus Absch�tzung von Insam


% F=k_i*k_ui*U + k_s*d; Linearisierte Kraftgleichung f�r Magnetlager bei
% geringen Auslenkungen und ohne S�ttigungseffekte

%% Datenstruktur f�r Kraft

%data_Kraft(1,:,:) = Lager 1, Kraft Z - Richtung
%data_Kraft(2,:,:) = Lager 1, Kraft Y - Richtung
%data_Kraft(3,:,:) = Lager 2, Kraft Z - Richtung
%data_Kraft(4,:,:) = Lager 2, Kraft Y - Richtung

for n_i=1:size(data,3)
    
    for i=2:11
        data_fit(i,:,n_i) = MLPS_FourierFit1_v02(data(1,:,n_i),data(i,:,n_i),n(n_i));
    end
    
    for i=1:4
        data_Kraft(i,:,n_i) = k_i*k_ui*data_fit(8+i-1,:,n_i) + k_s*data_fit(2+i-1,:,n_i);
    end
end

