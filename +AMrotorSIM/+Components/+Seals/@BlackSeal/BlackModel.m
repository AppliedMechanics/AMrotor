function [ M_seal,D_seal ,K_seal ] = BlackModel( self, sys, init )     
% Performs the BlackSeal calculations
%
%    :param sys: System parameters of the seal provided by the Config_file
%    :type sys: struct
%    :param init: Start values for the calculation (check function: get_loc_system_matrices)
%    :type init: struct
%    :return: M, D and K matrices of the seal

%BLACKMODEL gibt Koeffizienten nach Black zurück
%   nach    Black, Jenssen 1969-70 - Dynamic Hybrid Bearing Characteristics
%   und     Barrett - Turbulent Flow Annular Pump Seals
% global verfahrenb
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

%% Formeln zur Berechnung von lambda und Auswahl einer geeigneten Rechenvorschrift

% Ra = (2*sys.rho*Caxm*sys.S) / sys.nu
% Rc = (sys.rho*(sys.d/2)*omegaIR(1)*sys.S) / sys.nu
% sigma = lambda * sys.L / sys.S;
% Caxm = sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho);



%% Ra < 3000 (laminar flow)     (nach Barrett-Appendix; schreibt hier <= )
% lambda = 24 * Ra^-1;

i = 1;

fun=@(lambda) (24 * ((2*sys.rho*sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho)*sys.S) / sys.nu)^-1)) -lambda ;
lambda0=100;
options = optimset('Display','off');
lambda = fsolve(fun,lambda0,options);

sigma = lambda * sys.L / sys.S;
Caxm = sqrt((2*sys.p) / ((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho));
Ra = (2*sys.rho*Caxm*sys.S) / sys.nu;

if Ra > 3000
    
    
    % 3000 <= Ra <= 4200 (transition flow)
    % lambda = 1.9e-5 * Ra;
    
    i = 2;
    
    fun=@(lambda) (1.9e-5 * ((2*sys.rho*(sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho))*sys.S) / sys.nu))) -lambda ;
    lambda0=100;
    options = optimset('Display','off');
    lambda = fsolve(fun,lambda0,options);
    
    sigma = lambda * sys.L / sys.S;
    Caxm = sqrt((2*sys.p) / ((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho));
    Ra = (2*sys.rho*Caxm*sys.S) / sys.nu;
    
    
    if Ra > 4200
        % 4200 < Ra <= 42000
        % lambda = 0.079*Ra^(-0.25)*(1+((7*Rc)/(8*Ra))^2)^0.375
        
        i = 3;
        
        fun=@(lambda) 0.079*((2*sys.rho*(sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho))*sys.S) / sys.nu)^(-0.25)*(1+((7*((sys.rho*(sys.d/2)*init.omega0IR(1)*sys.S) / sys.nu))/(8*((2*sys.rho*(sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*(lambda * sys.L / sys.S))*sys.rho))*sys.S) / sys.nu)))^2)^0.375)) -lambda ;
        lambda0=100;
        options = optimset('Display','off');
        lambda = fsolve(fun,lambda0,options);
        
        sigma = lambda * sys.L / sys.S;
        Caxm = sqrt((2*sys.p) / ((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho));
        Ra = (2*sys.rho*Caxm*sys.S) / sys.nu;
        
        if Ra > 42000
            %error('Ra ist größer als 42000')
            i = 4;
        end
    end    
end

% verfahrenb(i) = verfahrenb(i)+1;

Rc = (sys.rho*(sys.d/2)*init.omega0IR(1)*sys.S) / sys.nu;
%%


% ändert sich sys.S mit der Zeit?



%% Berechnung von Caxm, Ra, sigma, lambda nach Barrett (Appendix) (mit sys,omegaIR als Eingangsgrößen)
% 
% % Annahme eines Wertes für Caxm
% Caxm = 20;
% i = 0;
% while i < 4 % nach Barrett sind 4 Wiederholungen notwendig
%     i = i + 1;
% Ra = (2*sys.rho*Caxm*sys.S) / sys.nu;
% Rc = (sys.rho*(sys.d/2)*omegaIR(1)*sys.S) / sys.nu;  %evtl falsches omega
% lambda = 0.079*Ra^(-0.25)*(1+((7*Rc)/(8*Ra))^2)^0.375;
% sigma = lambda * sys.L / sys.S;
% Caxm = sqrt((2*sys.p)/((sys.xi_aus+sys.xi_ein+2*sigma)*sys.rho))
% end
% 
% --- ENDE --- der Berechnung von Caxm, Ra, sigma, lambda nach Barrett (Appendix)
%%


T = sys.L / Caxm;
sys.p = 0.5 * (1+sys.xi_ein+2*sigma)*sys.rho*Caxm^2;    % oder ist sys.p der inlet pressure drop?

% Berechnung der u für short seal solution

u0 = ((1+sys.xi_ein)*sigma^2) / (1+sys.xi_ein+2*sigma)^2;
u1 = ((1+sys.xi_ein)^2*sigma+(1+sys.xi_ein)*(2.33+2*sys.xi_ein)*sigma^2+3.33*(1+sys.xi_ein)*sigma^3+1.33*sigma^4) / ((1+sys.xi_ein+2*sigma)^3);
u2 = (0.33*(1+sys.xi_ein)^2*(2*sys.xi_ein-1)*sigma+(1+sys.xi_ein)*(1+2*sys.xi_ein)*sigma^2+2*(1+sys.xi_ein)*sigma^3+1.33*sigma^4) / ((1+sys.xi_ein+2*sigma)^4);
u3 = (pi*(sys.d/2)*sys.p) / lambda;

% Anpassung für finite length seal

u0 = u0 / (1+0.28*(sys.L/(sys.d/2))^2);
u1 = u1 / (1+0.23*(sys.L/(sys.d/2))^2);
u2 = u2 / (1+0.06*(sys.L/(sys.d/2))^2);


Kd = u3 * (u0 - 0.25 * u2 * init.omega0IR(1)^2 * T^2);
kc = u3 * (0.5 * u1 * init.omega0IR(1) * T);
Cd = u3 * u1 * T;
cc = u3 * u2 * init.omega0IR(1) * T^2;
md = u3 * u2 * T^2;

M_seal = [md, 0; 0, md];
D_seal = [Cd, -cc; cc, Cd];
K_seal = [Kd, -kc; kc, Kd];
end

