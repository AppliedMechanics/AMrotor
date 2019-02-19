function Table = load_force_table(strFileName)
% LOAD_FORCE_TABLE: Kraftvektor aus Datei laden
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

%dof: [u_x, u_y, u_z, psi_x, psi_y]',


% time = 0:1e-3:1;
% Fx = sin(2*pi*30*time);
% Fy = zeros(size(time));
% Fz = zeros(size(time));
% Mx = zeros(size(time));;
% My = zeros(size(time));
% Mz = zeros(size(time));
% 
Table.time = time; % [s]
Table.force{1} = Fx; % [N]
Table.force{2} = Fy; % [N]
Table.force{3} = Fz; % [N]
Table.force{4} = Mx; % [Nm]
Table.force{5} = My; % [Nm]
Table.force{6} = Mz; % [Nm]

end