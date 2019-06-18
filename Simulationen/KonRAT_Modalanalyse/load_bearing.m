function Table = load_bearing(strFileName)
% LOAD_BEARING: Lager-Tabelle ausgeben
% 
% Table = load_bearing(strFileName)
% 
% Erstellt die Matrizen eines Kugellagers mit den Daten aus dem angegebenen
% mat-file und fuegt diese dem cnfg-struct hinzu. 
% Fuer ein Lager vom Typ 'LookUpTableBearing'. Die Datei mit den Lagerdaten 
% muss im selben Verzeichnis wie diese Funktion liegen. 
% 
% Beispielaufruf:
%   Table = load_bearing('bearingTPFax100.mat'); 

load(strFileName)
Table.stiffness_matrix = K_bearing; % [N/m]
%dof: [u_x, u_y, u_z, psi_x, psi_y]',
Table.damping_matrix = C_bearing;
Table.rpm = rpm;

end