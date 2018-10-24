function [ M_seal, D_seal ,K_seal ] = ChildsModel( self, init )
%Massen-, Dämpfungs- und Steifigkeitsmatrizen nach Childs (für EINE Dichtung!!)
%   für den Prüfstand sind 2 (oder auch 3) Dichtungen zu simulieren
%   init.omega0IR: 3-Dim-Vektor -> Drehung der Welle erfolgt in x-Richtung
%
%   in Anlehnung an:
%   D. W. Cilds: Dynamic Analysis of Turbulent Annular Seals Based On Hirs'
%   Lubrication Equation (1983)
%   Childs: seal radius =?  -> Wellenradius sys.d/2 
%       Dann stimmen die Koeffizienten zumindest mit denen von dyrobes.com überein
%       seal radius = sys.D oder sys.Dpw verschlechtern die Übereinstimmung lediglich (Aufzeichnung 24.01.)

sys = self.cnfg.sealModel.sys;

%% Koeffizienten nach Hirs
n0= 0.066;      % coefficients for Hirs' turbulence equations
m0 = -0.25;     % coefficients for Hirs' turbulence equations

%% Berechnung von lambda mit fsolve
% Ra = (sys.rho*Caxm*sys.S) / sys.nu;   % Hälfte der von Black definierten Reynoldszahl
% sigma = lambda * sys.L / sys.S;
% Caxm = sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho));
% b = Caxm/(sys.d/2 * omegaIR(1));
% lambda = n0 * Ra^m0*(1+1/(4*b^2))^((1+m0)/2)

fun=@(lambda) (n0 * ((sys.rho*(sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho)))*sys.S) / sys.nu)^m0*(1+1/(4*((sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho)))/(sys.d/2 * init.omega0IR(1)))^2))^((1+m0)/2)) - lambda;
lambda0=100;
options = optimset('Display','off');
lambda = fsolve(fun,lambda0,options);

%% mit gefundenem lambda Berechnung der übrigen Größen
sigma = lambda * sys.L / sys.S;
Caxm = sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho));

% Ra = (sys.rho*Caxm*sys.S) / sys.nu;   % Hälfte der von Black definierten Reynoldszahl
% Rc = (sys.rho*(sys.d/2)*omegaIR(1)*sys.S) / sys.nu;

T = sys.L / Caxm;

b = Caxm/(sys.d/2 * init.omega0IR(1));
beta = 1/(1+4*b^2);
B = 1+4*b^2*beta*(1+m0);
E = (1+sys.xi_ein)/(2*(1+sys.xi_ein+B*sigma));
a = sigma * (1+beta*(1+m0));
                             
% der Übersichtlichkeit/Performance wegen selbst definierte Koeffizienten u
%FIXME muss hier  ein "-" rein?; bei u_0
u0 = (pi*(sys.d/2)*sys.p) / lambda;
u1 = 1 + sys.xi_ein + 2*sigma;
u2 = 0.5*(1/6 + E);
u3 = E + 1/(a^2);

%% Berechnung der Koeffizienten
Kd = u0*(2*sigma^2)/u1 * ((1-m0)*E-((init.omega0IR(1)*T)^2)/(4*sigma)*(u2+2*sys.v0/a*(u3*(1-exp(-a))-(0.5+a^(-1))*exp(-a))));
kc = u0*(sigma^2*init.omega0IR(1)*T)/u1 * (E/sigma+B*u2+2*sys.v0/a*(E*B+(1/sigma - B/a)*((1-exp(-a))*(E+0.5+1/a)-1)));
Cd = u0*(2*sigma^2*T)/u1 * (E/sigma+B*u2);
cc = u0*(2*sigma*init.omega0IR(1)*T^2)/u1 * (u2+sys.v0/a*((1-exp(-a))*(u3+0.5)-(0.5+exp(-a)/a)));
md = u0*(sigma*(1/6 + E))/u1 * T^2;

%% Matrizen für output
M_seal = [md, 0; 0, md];
D_seal = [Cd, cc; -cc, Cd];
K_seal = [Kd, kc; -kc, Kd];

end

