function Table = load_seal_table(strFileName)
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
%   sealModel = load_seal_table('SealTestRigNew1.mat'); 

% Load Look up table for 'Table'
load(strFileName)
Table.stiffness_matrix = K_seal; % [N/m]
%dof: [u_x, u_y, u_z, psi_x, psi_y]',
Table.damping_matrix = C_seal;
Table.mass_matrix = M_seal;
Table.rpm = rpm;

end

