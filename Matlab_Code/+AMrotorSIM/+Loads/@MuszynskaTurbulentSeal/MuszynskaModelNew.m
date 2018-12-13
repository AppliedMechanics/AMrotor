function [ Koeff ] = MuszynskaModelNew( self, sys, init )
%MUSZYNSKAMODEL bestimmt die rotordynamischen Koeffizienten einer Dichtung.
%Alles Überprüft CW1 7.11.2018
%   Detailed explanation goes here
%   
%   Quellen:
%   [1] Hua2005
%   [2] Muszynska A. (1988). „Improvements in lightly loaded rotorbearing and rotorseal models“. In Journal of Vibration, Acoustics, Stress and Reliability in Design, Vol. 110, S.129–136.
%   [3] XIAOYAO SHEN 2009
%   [4] G Y Ying 2016
%%ToDo:
% Modellbeschreibung ergänzen.
% Quellen ergänzen.
% Koeffizienten n0, n1, n2 prüfen.
% Aufräumen, ordentliche  Nomenklatur.
% Wellenradius prüfen.(innen-, aussradius oder mittlerer???)


%% Koeffizienten nach Hirs(geklaut von ChildsModel)
% n0 = 0.066;%0.066; Schwierig, müsste man über Massenstrom herausfinden     % coefficients for Hirs' turbulence equations (=0.079 [Hua2005]) zu finden bei Lambda
m0 = -0.25;     % coefficients for Hirs' turbulence equations

%% Weitere Koeffizienten(geraten!)
n1 = 2;%2         % 0.5 < n1 < 3
n2 = 0.5;%0.5;%1%0.5;Schwierig, müsste man über Massenstrom herausfinden       % für nichtlineare Abhängigkeit der radialen Strömung von der Exzentrizität: 0 < n2 < 1

%% Modelgleichungen


% Iterative Berechnung des Reibungsfaktor
f0=100;
options = optimset('Display','off');
fun = @(lambda) residuumBernardo(lambda,sys,init);
f = fsolve(fun,f0,options);
% f = fsolve(@(lambda) residuumBernardo(lambda, sys, init),f0,options);
lambda=f;


u=sqrt((2*sys.p)/(sys.rho*(1+sys.xi_ein+(2*lambda*sys.L)/(sys.rL))));    % Glg. 4.11

%Volumenstrom
% dotv=u*sys.A;
% 
% R_a=(u*sys.rL)/(sys.nu);                                                 % Glg. 4.18

R=sys.R;                                                              % Wellendurchmesser

b=u/(R*init.omega0IR(1));                                               % Glg. 4.21 %richtiges Omega?

sigma=lambda*sys.L/sys.rL;

beta=1/(1+4*b^2);

T=sys.L/u;

B=1+4*b^2*beta*(1+m0);

E=(1+sys.xi_ein)/(2*(1+sys.xi_ein+B*sigma));
% 
% a=sigma*(1+beta*(1+m0));
% 
% alpha=sys.alpha;

%PASST: 14.11.2018 

%% Gleichungen 4.28 ff

mu0=(2*sigma^2*E*(1-m0))/(1+sys.xi_ein+2*sigma);

mu1=(2*sigma^2)/(1+sys.xi_ein+2*sigma)*(E/sigma +B/2*(1/6+E));

mu2=(sigma*(1/6+E))/(1+sys.xi_ein+2*sigma);

mu3=(pi*R*sys.p)/(lambda);



% k_ii=mu3*(mu0-mu2*(init.omega0IR(1)^2*T^2/4))-alpha*mu3*(init.omega0IR(1)^2*T^2/a)*(sigma/(1+sys.xi_ein+2*sigma))*((E+1/(a^2))*(1-exp(-a))-(1/2+1/a)*exp(-a));
% 
% k_ij=mu3*mu1*(init.omega0IR(1)*T/2)+alpha*mu3*(2*init.omega0IR(1)*T/a)*(sigma^2/(1+sys.xi_ein+2*sigma))*(E*B+(1/sigma-B/a)*((1-exp(-a))*(E+1/2+1/a)-1));
% 
% c_ii=mu3*mu1*T;
% 
% c_ij=mu3*mu2*init.omega0IR(1)*T^2 + alpha*init.omega0IR(1)*T^2*(2*sigma/(1+sys.xi_ein+2*sigma)*1/a)*((1-exp(-a))*(E+1/2+1/a^2)-(1/2+exp(-a)/a));

m_ii=mu3*mu2*T^2;



%% Bestimmung der rotordynamischen Koeffizienten
ke=mu3*mu0*(1-sys.ecc^2)^-n1;
ce=mu3*mu1*T*(1-sys.ecc^2)^-n1;
gamma=sys.gamma0*(1-sys.ecc)^n2;


Koeff.K_xx = ke-m_ii*gamma^2*init.omega0IR(1)^2;
Koeff.k_xy = gamma*init.omega0IR(1)*ce;
Koeff.k_yx = -Koeff.k_xy;
Koeff.K_yy = Koeff.K_xx;
Koeff.C_xx = ce;
Koeff.c_xy = 2*m_ii*gamma*init.omega0IR(1);
Koeff.c_yx = -Koeff.c_xy;
Koeff.C_yy = Koeff.C_xx;
Koeff.M_xx = m_ii;
Koeff.m_xy = 0;
Koeff.m_yx = 0;
Koeff.M_yy = Koeff.M_xx;

end


function [residual] = residuumBernardo(lambda,sys, init)
%Basierend auf der Diss von CW 
%   Kapitel 4. Gleichungen der Bulk-Flow-Formulation Passt! CW 17.11.2018
m0=-0.25;


u=sqrt((2*sys.p)/(sys.rho*(1+sys.xi_ein+(2*lambda*sys.L)/(sys.rL))));    % Glg. 4.11

R_a=(u*sys.rL)/(sys.nu);                                                 % Glg. 4.18

R=sys.R;                                                              % Wellendurchmesser

b=u/(R*init.omega0IR(1));                                               % Glg. 4.21 %richtiges Omega?

% sigma=lambda*sys.L/sys.rL;

beta=1/(1+4*b^2);

% T=sys.L/u;

B=1+4*b^2*beta*(1+m0);

% E=(1+sys.xi_ein)/(2*(1+sys.xi_ein+B*sigma));
% 
% a=sigma*(1+beta*(1+m0));
% 
% alpha=sys.alpha;

%% Koeffizienten nach CHILDS 
n0=0.066;


%%

lambda2=(n0*R_a^m0)*(1+1/(4*b^2))^((1+m0)/2);
residual=lambda2-lambda;





end

