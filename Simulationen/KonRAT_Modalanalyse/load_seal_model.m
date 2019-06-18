function sealModel = load_seal_model()
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
%   sealModel = load_seal_model()

% Seal-Coefficients for Childs/Black-Modell
tempSeal.T=42.5;
tempSeal.nu40=46;
tempSeal.nu100=7;
tempSeal.nut=tempSeal.nu40+((tempSeal.nu40-tempSeal.nu100)/(40-100))*(tempSeal.T-40);
sealModel.sys.v0 = 0;%-0.5;        
sealModel.sys.D = 16e-3; %sys.d + 2 * 0.1397e-3;          % Auszendurchmesser
sealModel.sys.d = sealModel.sys.D-2*0.00017;                       % Innendurchmesser
sealModel.sys.L = 0.02;                       % Spaltlaenge
sealModel.sys.R = (0.5*sealModel.sys.D+0.5*sealModel.sys.d)*0.5;  % Mittlerer Radius
sealModel.sys.Dpw = 0.5*(sealModel.sys.D+sealModel.sys.d);        % Mittlerer Durchmesser
sealModel.sys.S = 0.5*sealModel.sys.D-0.5*sealModel.sys.d;        % Spaltweite
sealModel.sys.xi_ein = 0.1;                   % Eintrittsverlust im Dichtspalt
sealModel.sys.xi_aus = 1;                     % Austrittsverlust im Dichtspalt
sealModel.sys.p = 15e5;                     % Druckdifferenz ueber Dichtung in Pa, N/m^2, 1bar=10^5Pa
sealModel.sys.rho = 880;                      % Dichte
sealModel.sys.nu = tempSeal.nut*sealModel.sys.rho*10^(-6);   


end
