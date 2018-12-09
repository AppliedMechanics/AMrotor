%Seal Geometry file
%Seal 1 for LOX Turbopump 
%Daten aus Padavala S.263 Bsp CHilds and Kim 1985

%Geometry
sys.d = 100e-3;                      % Innendurchmesser
sys.S = 0.17e-3 ;        % Spaltweite
sys.rL=sys.S;
sys.D = sys.d+sys.S*2;                        % Außendurchmesser
sys.L = 20e-3;%0.02;     % Spaltlänge

sys.A=(sys.D^2-sys.d^2)*pi/4;
sys.R = (0.5*sys.D+0.5*sys.d)*0.5;  % Mittlerer Radius
sys.Dpw = 0.5*(sys.D+sys.d);        % Mittlerer Durchmesser


sys.xi_ein = 0.1;%0.5;                   % Eintrittsverlust im Dichtspalt
sys.xi_aus = 1;%0.5;                   % Austrittsverlust im Dichtspalt

sys.p = 2e5;                      % Druckdifferenz über Dichtung in Pa, N/m^2, 1bar=10^5Pa
sys.rho = 880;                      % Dichte Kg/m^3
sys.eta = 40.48e-3;    	% dynamische Viskosität Pa*s My,Eta
sys.mu = sys.eta;  
sys.nu =  sys.eta/sys.rho;%nut*10^(-6);               %kinematische Viskosität m^2/s Ny =My/rho


% zusaetzliche Eintraege in sys im Vergleich zur Datei load_seal_model,
% welche fuer die statische Dichtungsmodellierung mit Black/Childs
% verwendet wird:
%   sys.A
%   sys.eta
%   sys.mu
%   sys.rL
%
% Im Gegensatz zu load_seal_model fehlt hier:
%   sys.v0