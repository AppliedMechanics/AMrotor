% Seal-Coefficients for Childs/Black-Modell
tempSeal.T=42.5;
tempSeal.nu40=46;
tempSeal.nu100=7;
tempSeal.nut=tempSeal.nu40+((tempSeal.nu40-tempSeal.nu100)/(40-100))*(tempSeal.T-40);
sys.v0 = 0;%-0.5;                      
sys.d = 0.1-2*0.00017;                       % Innendurchmesser
sys.D = 0.1; %sys.d + 2 * 0.1397e-3;          % Auszendurchmesser
sys.L = 0.02;                       % Spaltlaenge
sys.R = (0.5*sys.D+0.5*sys.d)*0.5;  % Mittlerer Radius
sys.Dpw = 0.5*(sys.D+sys.d);        % Mittlerer Durchmesser
sys.S = 0.5*sys.D-0.5*sys.d;        % Spaltweite
sys.xi_ein = 0.1;                   % Eintrittsverlust im Dichtspalt
sys.xi_aus = 1;                     % Austrittsverlust im Dichtspalt
sys.p = 3e5;                     % Druckdifferenz ueber Dichtung in Pa, N/m^2, 1bar=10^5Pa
sys.rho = 880;                      % Dichte
sys.nu = tempSeal.nut*sys.rho*10^(-6);   