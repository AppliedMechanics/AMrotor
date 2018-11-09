function sealModel = load_seal_table(strFileName)
% LOAD_SEAL_TABLE:Dichtungsmatrizen ausgeben
% 
% sealModel = load_seal_table(strFileName)
% 
% Erstellt die Matrizen einer Dichtung mit den Daten aus dem angegebenen
% mat-file und fuegt diese dem cnfg-struct hinzu. 
% Fuer eine Dichtung vom Typ 'Table'. Die Datei mit den Dichtungsdaten 
% muss im selben Verzeichnis wie diese Funktion liegen. 
% 
% Beispielaufruf:
%   sealModel = load_seal_table('Koeffizienten_Volumenstrom_2bar.mat'); 

% Load Look up table for 'Table'
load(strFileName)
sealModel.Table.rpm = wellendrehzahl;
sealModel.Table.m_xx = masse;
sealModel.Table.d_xx = hauptdaempfung;
sealModel.Table.d_xy = nebendaempfung;
sealModel.Table.k_xx = hauptsteifigkeit;
sealModel.Table.k_xy = nebensteifigkeit;

clear wellendrehzahl masse hauptdaempfung nebendaempfung hauptsteifigkeit nebensteifigkeit

end

