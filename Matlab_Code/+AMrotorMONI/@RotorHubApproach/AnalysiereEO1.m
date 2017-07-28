function [DrehzahlMess, RadiusMess, PhaseMess, OffsetXMess, OffsetYMess] = AnalysiereEO1(self,data)

% 2.2.2011 Markus Rossner
% Ziele:
% - Auslesen der Sensordaten
% - Berechnen Fourierreihe
% - Analyse der Erregerordnungen

Zeit = data(1,:).';
xPos = data(2,:).';
yPos = data(3,:).';
Tacho = data(4,:).';
phi = data(5,:).';

% Analysiere Drehzahl
DrehzahlMess = abs(mean(Tacho));

%% Fitting der x/y-Auslenkung mit Fourierreihe
fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-1, -1, -1, 0.8*DrehzahlMess*pi/30],'Upper',[1, 1, 1, 1.2*DrehzahlMess*pi/30],'Startpoint',[0, 0, 0, DrehzahlMess*pi/30]);
FX = fit(Zeit,xPos, fittype('fourier1'),fo);
if abs(FX.w-DrehzahlMess*pi/30)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe in X')
end
OffsetXMess = FX.a0;
AmplX = sqrt(FX.a1^2+FX.b1^2);
if FX.a1 >= 0
    PhaseX0 = -atan(FX.b1/FX.a1);
else
    PhaseX0 = -atan(FX.b1/FX.a1)-pi;
end

fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-1, -1, -1, 0.8*DrehzahlMess*pi/30],'Upper',[1, 1, 1, 1.2*DrehzahlMess*pi/30],'Startpoint',[0, 0, 0, DrehzahlMess*pi/30]);
FY = fit(Zeit,yPos, fittype('fourier1'),fo);
if abs(FY.w-DrehzahlMess*pi/30)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe in Y')
end
OffsetYMess = FY.a0;
if abs(FX.w-FY.w)>0.1
    disp('Achtung: Fourierreihe in X und Y mit unterschiedlicher Frequenz')
end
AmplY = sqrt(FY.a1^2+FY.b1^2);
if FY.a1 >= 0
    PhaseY0 = -atan(FY.b1/FY.a1);
else
    PhaseY0 = -atan(FY.b1/FY.a1)-pi;
end

%% Ermittlung Radius des Orbits
if abs(AmplX-AmplY)>0.01
    disp('Achtung: 1. EO des Orbit ist elliptisch')
end
RadiusMess = (AmplX+AmplY)/2;

%% Ermittlung Phase des Orbits

% Schritt 1: Ermittlung Zeitpunkte mit phi=0
if mean(Tacho)<0
    phi=-phi;
    disp('WARNUNG: Bestimmung der Phase funktioniert nicht fuer negative Drehzahl')
end
nRefRoh=find(phi<1); %suche potentielle Triggerstellen
nRef=0;

for n=2:length(nRefRoh) %suche tatsaechliche Triggerstellen
    if nRefRoh(n) ~= nRefRoh(n-1)+1
        nRef = [nRef, nRefRoh(n)];
    end
end
nRef(1)=[];

% Schritt 2: Ermittlung Phase zu Zeitpunkten mit phi=0
PhaseX = ((FX.w*Zeit(nRef)+PhaseX0))*180/pi;
PhaseY = ((FY.w*Zeit(nRef)+PhaseY0)+pi/2)*180/pi;

for n = 1:length(nRef)
    while PhaseX(n) < 0
        PhaseX(n) = PhaseX(n)+360;
    end
    while PhaseX(n) > 360
        PhaseX(n) = PhaseX(n)-360;
    end
    while PhaseY(n) < 0
        PhaseY(n) = PhaseY(n)+360;
    end
    while PhaseY(n) > 360
        PhaseY(n) = PhaseY(n)-360;
    end
end

% Schritt 3: Ermittlung mittlerer Phase
PhaseMess = (mean(PhaseX)+mean(PhaseY))/2;
% PhaseMess=mean(PhaseX);
% disp('### FUER NEGATIVE DREHZAHL ABGEAENDERT ###')
if max(abs(PhaseX-PhaseMess))>8
    disp('Achtung: Phase X weicht von mittlerer Phase ab')
end
if max(abs(PhaseY-PhaseMess))>8
    disp('Achtung: Phase Y weicht von mittlerer Phase ab')
end