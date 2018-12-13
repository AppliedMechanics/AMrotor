% TestRigNeu1
%Seal Geometry file
%Seal 1 for DPS at AMM TUM


%Geometry
sys.d = 45.99e-3;                      % Innendurchmesser
sys.D = 46.16e-3;                        % Außendurchmesser
sys.S = (sys.D-sys.d)/2;        % Spaltweite
sys.rL=sys.S;
sys.L = 20e-3;%0.02;     % Spaltlänge

sys.A=(sys.D^2-sys.d^2)*pi/4;
sys.R = (0.5*sys.D+0.5*sys.d)*0.5;  % Mittlerer Radius
sys.Dpw = 0.5*(sys.D+sys.d);        % Mittlerer Durchmesser


sys.xi_ein = 0.1;%0.5;                   % Eintrittsverlust im Dichtspalt
sys.xi_aus = 1;%0.5;                   % Austrittsverlust im Dichtspalt

sys.p = 5e5;                      % Druckdifferenz über Dichtung in Pa, N/m^2, 1bar=10^5Pa
sys.rho = 880;                      % Dichte Kg/m^3
sys.eta = 40.48e-3;    	% dynamische Viskosität Pa*s My,Eta
sys.mu = sys.eta;
sys.nu =  sys.eta/sys.rho;%nut*10^(-6);               %kinematische Viskosität m^2/s Ny =My/rho
