 function [sys,par]=ErzeugeKM()

%% Geometrie NDW Hohlwelle (x,da,di) in [mm]

Geometrie =  [0,8,0;700,8,0]*1e-3; % nur Welle

Geometrie(:,2:3)=Geometrie(:,2:3)/2; %Umrechnung Durchmesser zu Radius

% Material
E = 211e9;
rho = 7446;

% Diskretisierungsgrad
dz = 0.05; %Soll-Laenge eines Elementes fuer Modalanalyse


% Schwungscheibe mitte
z1 = 0.35; %m
m1 = 1.235; %kg
Ix1 = 1e-3; %kg*m^2
Iz1 = 3e-3; %kg*m^2

%Lagerhülsen links und rechts als Scheibe modelliert
z2 = 0.1;%m
m2 = 0.940;%kg
Iz2 = 4.588e-4; %kg*m^2
Ix2 = 6.589e-4; %kg*m^2

z3 = 0.6;%m
m3 = 0.940;%kg CATIA 0.908, + ca. 30Gramm für Spannhülse
Iz3 = 4.588e-4; %kg*m^2
Ix3 = 6.589e-4; %kg*m^2

% Lager
zLager1 = 0.1; %m
zLager2 = 0.6; %m
k_Lager=0; %N/m - Steifigkeit in beiden Lagern in beide Richtungen gleich


% =========================================================================
% Masse / Steifigkeit NDW
% =========================================================================

[Flaechentraegheit] = BerechneFlaechenmomente_Hohlwelle(Geometrie);
Knoten = Erstelle_Vernetzung(Geometrie, dz);
nKnoten = length(Knoten);
par.nKnoten=nKnoten;
% Masse Welle
M = Berechne_M(Geometrie, Flaechentraegheit, rho, Knoten);

% % Scheibe 1
n1=find(abs(Knoten-z1)<1e-4);
assert(length(n1)==1);
M(2*n1-1,2*n1-1)=M(2*n1-1,2*n1-1)+m1;
M(2*n1,2*n1)=M(2*n1,2*n1)+Ix1;
M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)=M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)+m1;
M(2*nKnoten+2*n1,2*nKnoten+2*n1)=M(2*nKnoten+2*n1,2*nKnoten+2*n1)+Ix1;

% Scheibe 2
n1=find(abs(Knoten-z2)<1e-4);
assert(length(n1)==1);
M(2*n1-1,2*n1-1)=M(2*n1-1,2*n1-1)+m2;
M(2*n1,2*n1)=M(2*n1,2*n1)+Ix2;
M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)=M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)+m2;
M(2*nKnoten+2*n1,2*nKnoten+2*n1)=M(2*nKnoten+2*n1,2*nKnoten+2*n1)+Ix2;

% Scheibe 3
n1=find(abs(Knoten-z3)<1e-4);
assert(length(n1)==1);
M(2*n1-1,2*n1-1)=M(2*n1-1,2*n1-1)+m3;
M(2*n1,2*n1)=M(2*n1,2*n1)+Ix3;
M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)=M(2*nKnoten+2*n1-1,2*nKnoten+2*n1-1)+m3;
M(2*nKnoten+2*n1,2*nKnoten+2*n1)=M(2*nKnoten+2*n1,2*nKnoten+2*n1)+Ix3;

% Steifigkeit
K1 = Berechne_K_B(Geometrie, Flaechentraegheit, E, Knoten);
K2 = ErgaenzeDiskreteFeder(Knoten, [k_Lager,k_Lager,zLager1; k_Lager,k_Lager,zLager2]);
%K2=0;
K = K1+K2;

par.Knoten = Knoten;
par.Geometrie = Geometrie;
par.Flaechentraegheit=Flaechentraegheit;

Knoten = par.Knoten;
nKnoten = length(Knoten);
D=sparse(4*nKnoten, 4*nKnoten);



% =========================================================================
% Gyroskopie + Daempfung
% =========================================================================

Gn = Berechne_Gn(Geometrie, Flaechentraegheit, rho, Knoten);
Nn = Berechne_Nn(Geometrie, Flaechentraegheit, rho, Knoten);

% Scheibe 1
n1=find(abs(Knoten-z1)<1e-4);
assert(length(n1)==1);
Gn(2*n1,2*nKnoten+2*n1)=Gn(2*n1,2*nKnoten+2*n1)-Iz1;
Gn(2*nKnoten+2*n1,2*n1)=Gn(2*nKnoten+2*n1,2*n1)+Iz1;
Nn(2*n1,2*nKnoten+2*n1)=Nn(2*n1,2*nKnoten+2*n1)-Iz1;
Nn(2*nKnoten+2*n1,2*n1)=Nn(2*nKnoten+2*n1,2*n1)+Iz1;

% Scheibe 2
n1=find(abs(Knoten-z2)<1e-4);
assert(length(n1)==1);
Gn(2*n1,2*nKnoten+2*n1)=Gn(2*n1,2*nKnoten+2*n1)-Iz2;
Gn(2*nKnoten+2*n1,2*n1)=Gn(2*nKnoten+2*n1,2*n1)+Iz2;
Nn(2*n1,2*nKnoten+2*n1)=Nn(2*n1,2*nKnoten+2*n1)-Iz2;
Nn(2*nKnoten+2*n1,2*n1)=Nn(2*nKnoten+2*n1,2*n1)+Iz2;


% Scheibe 3
n1=find(abs(Knoten-z3)<1e-4);
assert(length(n1)==1);
Gn(2*n1,2*nKnoten+2*n1)=Gn(2*n1,2*nKnoten+2*n1)-Iz3;
Gn(2*nKnoten+2*n1,2*n1)=Gn(2*nKnoten+2*n1,2*n1)+Iz3;
Nn(2*n1,2*nKnoten+2*n1)=Nn(2*n1,2*nKnoten+2*n1)-Iz3;
Nn(2*nKnoten+2*n1,2*n1)=Nn(2*nKnoten+2*n1,2*n1)+Iz3;


[DDI, KDI] = Berechne_Innere_Daempfung(Geometrie, Flaechentraegheit, rho, E, 0, 0, Knoten);


%%Vereinfachte Parameterüberegabe über Struct 

sys.K=K;
sys.M=M;
sys.D=D;
sys.G=Gn;
sys.N=Nn;
sys.DI=DDI;
sys.KI=KDI;

