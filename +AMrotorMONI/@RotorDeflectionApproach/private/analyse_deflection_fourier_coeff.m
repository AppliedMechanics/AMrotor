function [DrehzahlMess, Gleichlauf_Auslenkung, Gegenlauf_Auslenkung, StatischeAuslenkung,fourier] = analyse_deflection_fourier_coeff(self,Zeit,xPos,yPos,Tacho,phi)
%--------------------------------------------------------------------------
% Fourieranalyse gemäß der Fouerieranalyse der Kraftmessung



phi=phi*180/pi;
for i=1:length(phi)
if phi(i)>=360
    phi(i:end)=phi(i:end)-360;
end
end
 DrehzahlMess = abs(mean(Tacho));

%% Analysiere Winkel und Drehzahl
%phi2 = 180/pi*unwrap(phi*pi/180);

phi2=phi;
for lokal=2:length(phi2)
    if phi(lokal-1)>phi(lokal)
        phi2(lokal:end)=phi2(lokal:end)+360;
    end
end
% FitPhi = fit(Zeit.',phi2.',fittype('poly1'));
% PlotFitPhi = FitPhi.p1*Zeit+FitPhi.p2;% Macht winkel
%konstantsteigend
[~,Nulldurchgang]=min(abs(phi));

%% Interpolation Zeitpunkt Nulldurchgang
try
    ZeitNulldurchgang = Zeit(Nulldurchgang-1)+(Zeit(2)-Zeit(1))*(360-phi2(Nulldurchgang-1))/(phi2(Nulldurchgang)-phi2(Nulldurchgang-1));
    assert(isnan(ZeitNulldurchgang)~=1) %Interpolation gescheitert
catch
    ZeitNulldurchgang = Zeit(Nulldurchgang);
end

%% Exakte Drehzahl mit Encoder
OmegaExakt = pi/180*(phi2(end)-phi2(1))/(Zeit(end)-Zeit(1));
if abs((DrehzahlMess*2*pi/60)-OmegaExakt)>1
    disp('Achtung: Messrate zu gering für Drehzahlt')
end
%% Bestimmung der Zeit beim Überfahren des Referenzpunktes
% wenn hier ein Fehler auftaucht weil phi die Toleranzgrenze nicht
% überfährt ist es auch sinvoll die ZeitNulldurchgang zu verwenden
% z=find(phi<1);
% if isnan(z)
%     disp('Achtung: Nulldurchgang des Winkels mit Toleranzgrenze Phi[°]<1 wird nicht errreicht')
% end
% Zeit_Ref=Zeit(z(1));


%Auslesen des Zeitpunktes  
 Zeit_Ref=ZeitNulldurchgang;

    
%Verschieben des Nullpunktes der Zeitzählung
 Zeit=Zeit-Zeit_Ref;


%% Äquivalentes Ersetzen der gemessenen Positionswerte durch Resultierende
% Pos_x_res=zeros(1,length(Zeit));
% Pos_y_res=zeros(1,length(Zeit));


Pos_x_res=xPos;   %0.5*sqrt(2)*(data_Kraft_L1_1(:)-data_Kraft_L1_2(:));
Pos_y_res=yPos;   %0.5*sqrt(2)*(data_Kraft_L1_1(:)+data_Kraft_L1_2(:));

%% Fitting der Positionen mit Fourierreihe

%--------------------------------------------------------------------------
%Auslenkung in x-Richtung
% Ampl=zeros(8,4); %Matrix der Amplituden der Messdaten
% Phase=zeros(8,4); %Matrix der Phasen der Messdaten (bezogen auf 0 Grad Rotordrehung)
fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-Inf,-Inf,-Inf,0.8*DrehzahlMess*pi/30],'Upper',[Inf,Inf,Inf,1.2*DrehzahlMess*pi/30],'Startpoint',[0,0,0,DrehzahlMess*pi/30]);% Omega=DrehzahlMess*pi/30,  n[1/min]/60[s/min]*2*pi


AuslX = fit(Zeit.',Pos_x_res.', fittype('fourier1'),fo);
if abs(AuslX.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung linkes Lager')
end
OffsetXMess = AuslX.a0;
% Ampl(1,1) = [sqrt(RL1X.a1^2+RL1X.b1^2)];
% Phase(1,1) = [1*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b1,RL1X.a1)];

%Auslenkung in y-Richtung

AuslY = fit(Zeit.',Pos_y_res.', fittype('fourier1'),fo);
if abs(AuslY.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung linkes lager')
end
OffsetYMess = AuslY.a0;
% Ampl(1,2) = [sqrt(RL1Y.a1^2+RL1Y.b1^2)];
% Phase(1,2) = [1*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b1,RL1Y.a1)];




%Gleichlauf und Gegenlauf
%--------------------------------------------------------------------------


axAuslenkung=[AuslX.a1];
bxAuslenkung=[AuslX.b1];
ayAuslenkung=[AuslY.a1];
byAuslenkung=[AuslY.b1];

StatischeAuslenkung(:) =( OffsetXMess(:) + 1j* OffsetYMess(:) );

Gleichlauf_Auslenkung(:) = 1/2*(axAuslenkung(:)+byAuslenkung(:)+1j*(ayAuslenkung(:)-bxAuslenkung(:)));
Gegenlauf_Auslenkung(:) = 1/2*(axAuslenkung(:)-byAuslenkung(:)+1j*(ayAuslenkung(:)+bxAuslenkung(:)));




% % 2.2.2011 Markus Rossner
% % Ziele:
% % - Auslesen der Sensordaten
% % - Berechnen Fourierreihe
% % - Analyse der Erregerordnungen
% 
% % Zeit = data(1,:);
% % xPos = data(2,:);
% % yPos = data(3,:);
% % Tacho = data(4,:);
% % phi = data(5,:);
% 
% % Analysiere Drehzahl
% DrehzahlMess = abs(mean(Tacho));
% phi=phi*180/pi;
% for i=1:length(phi)
% if phi(i)>=360
%     phi(i:end)=phi(i:end)-phi(i);
% end
% end
% %% Fitting der x/y-Auslenkung mit Fourierreihe
% fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-inf, -inf, -inf, 0.8*DrehzahlMess*pi/30],'Upper',[inf, inf, inf, 1.2*DrehzahlMess*pi/30],'Startpoint',[0, 0, 0, DrehzahlMess*pi/30]);
% FX = fit(Zeit.',xPos.', fittype('fourier1'),fo);
% if abs(FX.w-DrehzahlMess*pi/30)>1
%     disp('Achtung: Fehler bei Frequenz der Fourierreihe in X')
% end
% OffsetXMess = FX.a0;
% AmplX = sqrt(FX.a1^2+FX.b1^2);
% if FX.a1 >= 0
%     PhaseX0 = -atan(FX.b1/FX.a1);
% else
%     PhaseX0 = -atan(FX.b1/FX.a1)-pi;
% end
% 
% fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-inf, -inf, -inf, 0.8*DrehzahlMess*pi/30],'Upper',[inf, inf, inf, 1.2*DrehzahlMess*pi/30],'Startpoint',[0, 0, 0, DrehzahlMess*pi/30]);
% FY = fit(Zeit.',yPos.', fittype('fourier1'),fo);
% if abs(FY.w-DrehzahlMess*pi/30)>1
%     disp('Achtung: Fehler bei Frequenz der Fourierreihe in Y')
% end
% OffsetYMess = FY.a0;
% if abs(FX.w-FY.w)>0.1
%     disp('Achtung: Fourierreihe in X und Y mit unterschiedlicher Frequenz')
% end
% AmplY = sqrt(FY.a1^2+FY.b1^2);
% if FY.a1 >= 0
%     PhaseY0 = -atan(FY.b1/FY.a1);
% else
%     PhaseY0 = -atan(FY.b1/FY.a1)-pi;
% end
% 
% %% Ermittlung Radius des Orbits
% if abs(AmplX-AmplY)>0.01
%     disp('Achtung: 1. EO des Orbit ist elliptisch')
% end
% RadiusMess = (AmplX+AmplY)/2;
% 
% %% Ermittlung Phase des Orbits
% 
% % Schritt 1: Ermittlung Zeitpunkte mit phi=0
% if mean(Tacho)<0
%     phi=-phi;
%     disp('WARNUNG: Bestimmung der Phase funktioniert nicht fuer negative Drehzahl')
% end
% nRefRoh=find(phi<1); %suche potentielle Triggerstellen
% nRef=0;
% 
% for n=2:length(nRefRoh) %suche tatsaechliche Triggerstellen
%     if nRefRoh(n) ~= nRefRoh(n-1)+1
%         nRef = [nRef, nRefRoh(n)];
%     end
% end
% nRef(1)=[];
% 
% % Schritt 2: Ermittlung Phase zu Zeitpunkten mit phi=0
% PhaseX = ((FX.w*Zeit(nRef)+PhaseX0))*180/pi;
% PhaseY = ((FY.w*Zeit(nRef)+PhaseY0)+pi/2)*180/pi;
% 
% for n = 1:length(nRef)
%     while PhaseX(n) < 0
%         PhaseX(n) = PhaseX(n)+360;
%     end
%     while PhaseX(n) > 360
%         PhaseX(n) = PhaseX(n)-360;
%     end
%     while PhaseY(n) < 0
%         PhaseY(n) = PhaseY(n)+360;
%     end
%     while PhaseY(n) > 360
%         PhaseY(n) = PhaseY(n)-360;
%     end
% end
% 
% % Schritt 3: Ermittlung mittlerer Phase
% PhaseMess = (mean(PhaseX)+mean(PhaseY))/2;
% % PhaseMess=mean(PhaseX);
% % disp('### FUER NEGATIVE DREHZAHL ABGEAENDERT ###')
% if max(abs(PhaseX-PhaseMess))>8
%     disp('Achtung: Phase X weicht von mittlerer Phase ab')
% end
% if max(abs(PhaseY-PhaseMess))>8
%     disp('Achtung: Phase Y weicht von mittlerer Phase ab')


fourier.x=AuslX;
fourier.y=AuslY;
fourier.Zeit=Zeit;
fourier.xPos=Pos_x_res;
fourier.yPos=Pos_y_res;
fourier.omega=DrehzahlMess*2*pi/60;
end