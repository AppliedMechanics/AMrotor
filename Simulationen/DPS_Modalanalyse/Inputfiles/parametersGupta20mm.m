%Bearing FAG6404

%All in SI

%% Balls
par.N = 6; %Number of Balls
par.D = 8e-3; %Ball diameter
par.E = 1.99948*1e11;
par.nu = 0.25;
par.m=0.002077;%Masse
par.J=2/5 * par.m *(0.5*par.D)^2;
par.M=0.1;

%% Inner ring
par.dbi=23e-3-0.1107e-3/2; %inner raceway diameter
par.ri=0.56*par.D; %Race radius
par.mui=0.1; %Friction Factor
par.Di=20e-3;%Innenring Bohrung

%% Outer ring
par.dbo=39e-3+0.1107e-3/2; %outer raceway diameter
par.ro=0.52*par.D; %Race radius
par.muo=0.1;
par.Do=50e-3;

%race curvature factor
par.fi=par.ri/par.D;
par.fo=par.ro/par.D;

% Pitch diameter
par.dbm = ((par.dbo + par.dbi)/2);

%radii of inner racewaygroove curvature centers
par.rj=par.dbi/2 +par.ri;

%Clearance
par.rL=par.dbo-par.dbi-2*par.D;

%Unloaded contact angle and distance between race radii centers (to Bastien)
par.A0=par.ri+par.ro-par.D;
par.alpha0=acos(1-(par.rL/(2*par.A0)));%Bastien
alpha0=par.alpha0*360/(2*pi);
%par.alpha0=0;


%Inner ring contact
% rohxy     - Radius Körper x - Ebene y   [m](Konvex +; Konkav -)
r11=par.D/2;
r12=par.D/2;
r22=-par.ri;
r21=(par.dbm/cos(par.alpha0)-par.D)/2; 
E1=par.E;
E2=par.E;
nu1=par.nu;
nu2=par.nu;

[Ki,awq,bwq,KappaWensing,EpsWensing,epsWensing] = hertzian4(r11,r12,E1,nu1,r21,r22,E2,nu2);%in N/(mm)^1,5
par.epsWensingi=epsWensing;
par.KappaWensingi=KappaWensing;
par.EpsWensingi=EpsWensing;
par.awqi=awq;
par.bwqi=bwq;
%[Ki] = hertzWensing(r11,r12,E1,nu1,r21,r22,E2,nu2)
%Ki=Ki*((1e-3)^1.5);
par.Ki=Ki; %in N/(m)^1,5


%Outer ring contact
% rohxy     - Radius Körper x - Ebene y   [m](Konvex +; Konkav -)
r11=par.D/2;
r12=par.D/2;
r22=-par.ro;
r21=-(par.dbm/cos(par.alpha0)+par.D)/2;
E1=par.E;
E2=par.E;
nu1=par.nu;
nu2=par.nu;
[Ko,awq,bwq,KappaWensing,EpsWensing,epsWensing] = hertzian4(r11,r12,E1,nu1,r21,r22,E2,nu2);
par.epsWensingo=epsWensing;
par.KappaWensingo=KappaWensing;
par.EpsWensingo=EpsWensing;
par.awqo=awq;
par.bwqo=bwq;
%[Ko] = hertzWensing(r11,r12,E1,nu1,r21,r22,E2,nu2)
%Ko=Ko*((1e-3)^1.5);
par.Ko=Ko; %in N/(m)^1,5
%effective stiffness to cw
%par.K= ( 1/( (1/Ki)^(2/3) + (1/Ko)^(2/3) ) )^(3/2)
par.K=Ki*Ko/((Ki^(2/3) +Ko^(2/3)))^(3/2);

Vergleich=par.K/465883;

%Fluid Eigenschaften für EHD Steifigkeit und Dämpfung

par.alphaP=1.5189e-8;%pressure-viscosity coefficient in 1/Pa
par.eta0=0.027747;%0.1;    Pas   %nominal viscosity
% par.omega=2*pi*(10/60);%1000;     %rotational shaft speed
par.psi=0.015; %Material damping dry

%par.rL=0;


function [Ks,awq,bwq,KappaWensing,EpsWensing,epsWensing] = hertzian4(r11,r12,E1,nu1,r21,r22,E2,nu2)
% Berechne Eindringung/Kraft zweier Körper nach Näherungsverfahren aus 
% "Simulation und experimentelle Analyse der Dynamik waelzgelagerter
% Rotoren"; Oest 2004,  isbn 3832229698
%
%Geprüft und Erweitert von CW 22.05.2018

% ##### INPUT
% rohxy     - Radius Körper x - Ebene y   [m](Konvex +; Konkav -)
% Ex        - E-Modul Körper x              [N/mm^2] (Stahl: 210000)
% nux       - Poisson Zahl Körper x         [1] (Stahl: 0.3)
% X         - Kraft [N] (Schalter = 1) / Eindringung [m] (Schalter = 0)
% ##### OUTPUT
% Ks        - Steifigkeitsparameter [N/(m^(3/2))]

%Rechne Radien in Krümmungen [1/m] um
roh11 = 1/(r11);
roh12 = 1/(r12);
roh21 = 1/(r21);
roh22 = 1/(r22);

% Berechne reduziertes E-Modul nach Fritz
Ered = 2*E1*E2/(E1*(1-nu1^2)+E2*(1-nu2^2));

%Berechne SumRoh
SumRoh = roh11+roh12+roh21+roh22;

EredOest=0.5*((1-nu1^2)/E1 + (1-nu2^2)/E2);

% Berechne Hilfswert cosTau
cosTau = sqrt((roh11-roh12)^2+(roh21-roh22)^2+2*(roh11-roh12)*(roh21-roh22))/SumRoh;

% Berechne Zwischenwert fTau
fTau = log(1-cosTau);

% Berechne Xi und eta
if cosTau <= 0.949
    Xi = exp((fTau)/(-1.53+0.333*fTau+0.0467*(fTau^2)));
    eta = exp((fTau)/(1.525 - 0.86*fTau - 0.0993*(fTau^2)));

else
    Xi = exp(sqrt(-0.4567 -0.4446 * fTau + 0.1238 *(fTau^2)));
    eta = exp(-0.333 + 0.2037 *fTau + 0.0012 *(fTau^2));
end

% Berechne K
Kappa = Xi/eta;

% Berechne M
%M = Xi^(3)*pi/(2*K^2);
M=eta^3 *pi*Kappa/2;

% Berechne N
N=0.5*(-cosTau*M*(Kappa^2-1)+M*(Kappa^2+1));


% Berechne zeta
zeta = 2*N/(pi*Xi);

%Steifigkeit
Ks=sqrt(3)*Ered*(1/(1.5*zeta*SumRoh^(1/3)))^1.5;

%KsOest=sqrt(3)/EredOest *(1/(1.5*zeta*SumRoh^(1/3)))^1.5;

% Berechne Kraft
%      delta = 0.0015e-3;
%    Q=Ks*delta^1.5;
%Parameter zur Ellipsenintegration, without force Q^(1/3)
awq= Xi*(3*EredOest/SumRoh )^(1/3) ;
bwq= eta*(3*EredOest/SumRoh)^(1/3) ;

KappaWensing=N;
EpsWensing=M;
epsWensing=1/Kappa;

end

