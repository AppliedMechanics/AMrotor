% function RitzSimBestimmungMatrizen()

clc
clear all
close all

addpath(strcat(fileparts(which(mfilename)),'/RitzSim'));

%% FEM-ANALYSE EINES ROTORS
% 8.12.2010
%
% - Modellierung des Rotors als Bernoulli-Balken
% - Balken-Standard-KOS
% - Auswertung der FE in ROTIERENDEM KOS !
% - bei x=0 Festlager, bei x=Laenge Loslager
% - Realisierung durch Streichen dof, allerdings erst direkt vor Berechnung
% - Reihenfolge der dofs: Verschiebung in y, Drehung um z, Verschiebung in
% z, Drehung um y, Zug/Druck-Dehnung, Torsion
% - keine weiteren Scheiben

% =========================================================================
% Parameter
% =========================================================================

% Geometrie NDW

Geometrie =  [0,20,0; 75,25,0; 150,25,0; 400,25,0; 500,25,0]*1e-3; % nur Welle
Geometrie(:,2:3)=Geometrie(:,2:3)/2; %Umrechnung Durchmesser zu Radius

% Material
E = 211e9;
rho = 7446;

% Diskretisierungsgrad
dz = 0.005; %Soll-Laenge eines Elementes fuer Modalanalyse
Moden = 10; %Anzahl Freiheitsgrade nach Modalanalyse

% Schwungscheiben
% Massen fehlen! Polares Traegheitsmoment als 2*I_Kipp abgeschaetzt. Das
% gibt obere Grenze des gyroskopischen Effekts
z1 = 0;
m1 = 0.2685;
Ix1 = 1.23e-4;
Iz1 = 7.97e-5;

z2 = 150e-3;
m2 = 0.2027;  %0.2 kg fehlen bei Gesamtwelle, wird hier aufgeschlagen, da in dieser Gegend sehr vereinfacht
Ix2 = 9.44e-5;
Iz2 = 1.78e-4;

z3 = 500e-3;
m3 = 0.606;
Ix3 = 7.84e-4;
Iz3 = 1.56e-3;

% Lager
zLager1 = 75e-3;
zLager2 = 400e-3;
% k_Lager = 1.09e7;
k_Lager=1.59e8; %nach neuer Simulation Sudhof sind Lager deutlich steifer

% =========================================================================
% Masse / Steifigkeit NDW
% =========================================================================

[Flaechentraegheit] = BerechneFlaechenmomente_Hohlwelle(Geometrie);
Knoten = Erstelle_Vernetzung(Geometrie, dz);
nKnoten = length(Knoten);

% Masse Welle
M = Berechne_M(Geometrie, Flaechentraegheit, rho, Knoten);

% Scheibe 1
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
K = K1+K2;
 
% =========================================================================
% Ausgabe EV
% =========================================================================

nMat = 2*nKnoten;
K_EW = K(1:nMat, 1:nMat);
M_EW = M(1:nMat, 1:nMat);
A = [zeros(nMat,nMat), eye(nMat, nMat); -M_EW\K_EW, zeros(nMat,nMat)];
[EVa, EWa] = eigenshuffle(A);
EV1a = EV_Extraktion(EVa,Moden); %Reellifizierung und Normierung der EW auf maximales v / w = 1

K_EW = K(nMat+1:2*nMat, nMat+1:2*nMat);
M_EW = M(nMat+1:2*nMat, nMat+1:2*nMat);
A = [zeros(nMat,nMat), eye(nMat, nMat); -M_EW\K_EW, zeros(nMat,nMat)];
[EVb, EWb] = eigenshuffle(A);
EV1b = EV_Extraktion(EVb,Moden);

EV2 = EV_Aufbereitung2(EV1a, EV1b, M, Moden, 3e-7); %Weitere Vereinfachung und Massennormierung der EV


% =========================================================================
% Plot Schwingform
% =========================================================================

Lagerpos = [zLager1, zLager2];
subplot(3,1,1)
plot(Knoten,EV1a(1:2:end-1,1),'b', Lagerpos,interp1(Knoten,EV1a(1:2:end-1,1),Lagerpos,'spline'),'ob')
subplot(3,1,2)
plot(Knoten,EV1a(1:2:end-1,3),'b', Lagerpos,interp1(Knoten,EV1a(1:2:end-1,3),Lagerpos,'spline'),'ob')
subplot(3,1,3)
plot(Knoten,EV1a(1:2:end-1,5),'b', Lagerpos,interp1(Knoten,EV1a(1:2:end-1,5),Lagerpos,'spline'),'ob')

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
[DDA] = ErgaenzeDiskreteDaempfer(Knoten, [0,0,zLager1; 0,0,zLager2]);


% =========================================================================
% EW-Analyse im rotierenden Fall -> Kreiselwirkung
% =========================================================================

dOmega=0;
Omega=0:100:3000;
EFMatrix = zeros(length(Omega), 2*Moden);

Arot=zeros(8*nKnoten,8*nKnoten,length(Omega));

for n1 = 1:length(Omega)
    DG = DDI + DDA + Gn*Omega(n1);
    KN = K + Omega(n1)*KDI + dOmega*Nn;
    Arot(:,:,n1) = [zeros(4*nKnoten,4*nKnoten), eye(4*nKnoten,4*nKnoten); -M\KN, -M\DG];
end

[~,EWrot] = eigenshuffle(Arot);
figure
plot(Omega,Omega,'b', Omega,imag(EWrot(1,:)),'g', Omega,imag(EWrot(3,:)),'g', Omega,imag(EWrot(5,:)),'r', Omega,imag(EWrot(7,:)),'r', Omega,imag(EWrot(9,:)),'k', Omega,imag(EWrot(11,:)),'k')

%=========================================================================
% Bestimmung Whirl-Richtung
% =========================================================================
% 
% Omega=3000;
% dOmega=0;
% AuswahlKnoten=1;
% AuswahlESF=6;
% 
% DG = DDI + DDA + Gn*Omega;
% KN = K + Omega*KDI + dOmega*Nn;
% Arot = [zeros(4*nKnoten,4*nKnoten), eye(4*nKnoten,4*nKnoten); -M\KN, -M\DG];
% [EVrot,EWrot]=eigenshuffle(Arot);
% 
% gamma=0:0.2:2*pi;
% ux = EVrot(AuswahlKnoten*2-1,AuswahlESF*2-1)*exp(1j*gamma)+EVrot(AuswahlKnoten*2-1,AuswahlESF*2)*exp(-1j*gamma);
% uy = EVrot(2*nKnoten+AuswahlKnoten*2-1,AuswahlESF*2-1)*exp(1j*gamma)+EVrot(2*nKnoten+AuswahlKnoten*2-1,AuswahlESF*2)*exp(-1j*gamma);
% plot(ux,uy,'-b', ux(1),uy(1),'ob',ux(5),uy(5),'rs')

save wagner2.mat