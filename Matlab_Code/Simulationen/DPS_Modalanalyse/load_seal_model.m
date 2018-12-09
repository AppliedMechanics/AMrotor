function sealModel = load_seal_model(strFileName)
% LOAD_SEAL_MODEL: Dichtungsparameter ausgeben
% 
% sealModel = load_seal_model()
% 
% Laedt die Parameter einer Dichtung fuer das Black/Childs-Model mit den
% Daten aus dem angegebenen  mat-file und fuegt diese dem cnfg-struct
% hinzu.
% Fuer eine Dichtung vom Typ 'Black' oder 'Childs. Die Datei mit den
% Dichtungsdaten  muss im selben Verzeichnis wie diese Funktion liegen. 
% 
% Beispielaufruf:
%   sealModel = load_seal_model('ChildsBlackModelParameters.m')

run(strFileName)
sealModel.sys = sys;


end
