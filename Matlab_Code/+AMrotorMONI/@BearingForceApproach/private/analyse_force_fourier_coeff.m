function [DrehzahlMess,OmegaExakt,Gleichlauf_FL1,Gegenlauf_FL1, Gleichlauf_FL2, Gegenlauf_FL2]=analyse_force_fourier_coeff(self,data)

%Einlesen der Daten

Zeit=data(1,:);
Tacho = data(4,:); %Drehzahl [1/min]
phi = data(5,:);   %Winkel [°]

data_Kraft_L1_1=data(7,:); %Kraft in [N]
data_Kraft_L1_2=data(8,:);

data_Kraft_L2_1=data(9,:); %Kraft in [N]
data_Kraft_L2_2=data(10,:);

%Messwinkel=[90,180]*pi/180;

DrehzahlMess = abs(mean(Tacho));

%% Analysiere Winkel und Drehzahl
phi2 = 180/pi*unwrap(phi*pi/180);
FitPhi = fit(Zeit.',phi2.',fittype('poly1'));
PlotFitPhi = FitPhi.p1*Zeit+FitPhi.p2;
[~,Nulldurchgang]=min(abs(PlotFitPhi-360));

try
    ZeitNulldurchgang = Zeit(Nulldurchgang-1)+(Zeit(2)-Zeit(1))*(360-phi2(Nulldurchgang-1))/(phi2(Nulldurchgang)-phi2(Nulldurchgang-1));
    assert(isnan(ZeitNulldurchgang)~=1) %Interpolation gescheitert
catch
    ZeitNulldurchgang = Zeit(Nulldurchgang);
end

%% Exakte Drehzahl mit Encoder
OmegaExakt = pi/180*(phi2(end)-phi2(1))/(Zeit(end)-Zeit(1));

%% Bestimmung der Zeit beim Überfahren des Referenzpunktes
Zeit_diff=zeros(1,length(Zeit)); %Zeitpunkt beim Überfahren des Referenzpunktes
%Bilden der Differenz zweier aufeinanderfolgender Werte
for i=1:1:length(Zeit)-1
    Zeit_diff(i)=phi(i+1)-phi(i);
end
%Suchen des ersten großen Sprungs
[t,z,v] = find(abs(Zeit_diff)>350);
%Auslesen des Zeitpunktes  
Zeit_Ref=Zeit(z(1));

%Verschieben des Nullpunktes der Zeitzählung
Zeit=Zeit-Zeit_Ref;


%% Äquivalentes Ersetzen der gemessenen Kraftwerte durch Resultierende
FL1_x_res=zeros(1,length(Zeit));
FL1_y_res=zeros(1,length(Zeit));
FL2_x_res=zeros(1,length(Zeit));
FL2_y_res=zeros(1,length(Zeit));

FL1_x_res(:)=0.5*sqrt(2)*(data_Kraft_L1_1(:)-data_Kraft_L1_2(:));
FL1_y_res(:)=0.5*sqrt(2)*(data_Kraft_L1_1(:)+data_Kraft_L1_2(:));
FL2_x_res(:)=0.5*sqrt(2)*(data_Kraft_L2_1(:)-data_Kraft_L2_2(:));
FL2_y_res(:)=0.5*sqrt(2)*(data_Kraft_L2_1(:)+data_Kraft_L2_2(:));

%% Fitting der Kräfte mit Fourierreihe

% Rechung Lager 1
%--------------------------------------------------------------------------
%Kraft in x-Richtung
Ampl=zeros(8,4); %Matrix der Amplituden der Messdaten
Phase=zeros(8,4); %Matrix der Phasen der Messdaten (bezogen auf 0 Grad Rotordrehung)
fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,0.8*DrehzahlMess*pi/30],'Upper',[Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,1.2*DrehzahlMess*pi/30],'Startpoint',[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,DrehzahlMess*pi/30]);


RL1X = fit(Zeit.',FL1_x_res.', fittype('fourier8'),fo);
if abs(RL1X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung Gleitlager')
end
Offset_L1X(1) = RL1X.a0;
Ampl(1:8,1) = [sqrt(RL1X.a1^2+RL1X.b1^2);
                sqrt(RL1X.a2^2+RL1X.b2^2);
                sqrt(RL1X.a3^2+RL1X.b3^2);
                sqrt(RL1X.a4^2+RL1X.b4^2);
                sqrt(RL1X.a5^2+RL1X.b5^2);
                sqrt(RL1X.a6^2+RL1X.b6^2);
                sqrt(RL1X.a7^2+RL1X.b7^2);
                sqrt(RL1X.a8^2+RL1X.b8^2)];
Phase(1:8,1) = [1*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b1,RL1X.a1);
                2*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b2,RL1X.a2);
                3*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b3,RL1X.a3);
                4*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b4,RL1X.a4);
                5*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b5,RL1X.a5);
                6*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b6,RL1X.a6);
                7*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b7,RL1X.a7);
                8*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b8,RL1X.a8)];

%Kraft in y-Richtung

RL1Y = fit(Zeit.',FL1_y_res.', fittype('fourier8'),fo);
if abs(RL1X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung Gleitlager')
end
Offset_L1Y(1) = RL1Y.a0;
Ampl(1:8,2) = [sqrt(RL1Y.a1^2+RL1Y.b1^2);
                sqrt(RL1Y.a2^2+RL1Y.b2^2);
                sqrt(RL1Y.a3^2+RL1Y.b3^2);
                sqrt(RL1Y.a4^2+RL1Y.b4^2);
                sqrt(RL1Y.a5^2+RL1Y.b5^2);
                sqrt(RL1Y.a6^2+RL1Y.b6^2);
                sqrt(RL1Y.a7^2+RL1Y.b7^2);
                sqrt(RL1Y.a8^2+RL1Y.b8^2)];
Phase(1:8,2) = [1*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b1,RL1Y.a1);
                2*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b2,RL1Y.a2);
                3*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b3,RL1Y.a3);
                4*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b4,RL1Y.a4);
                5*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b5,RL1Y.a5);
                6*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b6,RL1Y.a6);
                7*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b7,RL1Y.a7);
                8*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b8,RL1Y.a8)];

%Rechnung Lager 2
%--------------------------------------------------------------------------
%Kraft in x-Richtung
RL2X = fit(Zeit.',FL2_x_res.', fittype('fourier8'),fo);
if abs(RL2X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung Gleitlager')
end
Offset_L2X(1) = RL2X.a0;
Ampl(1:8,3) = [sqrt(RL2X.a1^2+RL2X.b1^2);
                sqrt(RL2X.a2^2+RL2X.b2^2);
                sqrt(RL2X.a3^2+RL2X.b3^2);
                sqrt(RL2X.a4^2+RL2X.b4^2);
                sqrt(RL2X.a5^2+RL2X.b5^2);
                sqrt(RL2X.a6^2+RL2X.b6^2);
                sqrt(RL2X.a7^2+RL2X.b7^2);
                sqrt(RL2X.a8^2+RL2X.b8^2)];
Phase(1:8,3) = [1*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b1,RL2X.a1);
                2*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b2,RL2X.a2);
                3*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b3,RL2X.a3);
                4*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b4,RL2X.a4);
                5*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b5,RL2X.a5);
                6*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b6,RL2X.a6);
                7*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b7,RL2X.a7);
                8*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b8,RL2X.a8)];

%Kraft in y-Richtung

RL2Y = fit(Zeit.',FL2_y_res.', fittype('fourier8'),fo);
if abs(RL2X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung Gleitlager')
end
Offset_L2Y(1) = RL2Y.a0;
Ampl(1:8,4) = [sqrt(RL2Y.a1^2+RL2Y.b1^2);
                sqrt(RL2Y.a2^2+RL2Y.b2^2);
                sqrt(RL2Y.a3^2+RL2Y.b3^2);
                sqrt(RL2Y.a4^2+RL2Y.b4^2);
                sqrt(RL2Y.a5^2+RL2Y.b5^2);
                sqrt(RL2Y.a6^2+RL2Y.b6^2);
                sqrt(RL2Y.a7^2+RL2Y.b7^2);
                sqrt(RL2Y.a8^2+RL2Y.b8^2)];
Phase(1:8,4) = [1*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b1,RL2Y.a1);
                2*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b2,RL2Y.a2);
                3*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b3,RL2Y.a3);
                4*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b4,RL2Y.a4);
                5*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b5,RL2Y.a5);
                6*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b6,RL2Y.a6);
                7*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b7,RL2Y.a7);
                8*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b8,RL2Y.a8)];
            
            
%Gleichlauf und Gegenlauf
%--------------------------------------------------------------------------

Gleichlauf_FL1 = linspace(0,0,8);
Gegenlauf_FL1 = linspace(0,0,8);
Gleichlauf_FL2 = linspace(0,0,8);
Gegenlauf_FL2 = linspace(0,0,8);

axiL1=[RL1X.a1;RL1X.a2;RL1X.a3;RL1X.a4;RL1X.a5;RL1X.a6;RL1X.a7;RL1X.a8];
bxiL1=[RL1X.b1;RL1X.b2;RL1X.b3;RL1X.b4;RL1X.b5;RL1X.b6;RL1X.b7;RL1X.b8];
ayiL1=[RL1Y.a1;RL1Y.a2;RL1Y.a3;RL1Y.a4;RL1Y.a5;RL1Y.a6;RL1Y.a7;RL1Y.a8];
byiL1=[RL1Y.b1;RL1Y.b2;RL1Y.b3;RL1Y.b4;RL1Y.b5;RL1Y.b6;RL1Y.b7;RL1Y.b8];


axiL2=[RL2X.a1;RL2X.a2;RL2X.a3;RL2X.a4;RL2X.a5;RL2X.a6;RL2X.a7;RL2X.a8];
bxiL2=[RL2X.b1;RL2X.b2;RL2X.b3;RL2X.b4;RL2X.b5;RL2X.b6;RL2X.b7;RL2X.b8];
ayiL2=[RL2Y.a1;RL2Y.a2;RL2Y.a3;RL2Y.a4;RL2Y.a5;RL2Y.a6;RL2Y.a7;RL2Y.a8];
byiL2=[RL2Y.b1;RL2Y.b2;RL2Y.b3;RL2Y.b4;RL2Y.b5;RL2Y.b6;RL2Y.b7;RL2Y.b8];

Gleichlauf_FL1(:) = 1/2*(axiL1(:)+byiL1(:)+1j*(ayiL1(:)-bxiL1(:)));
Gegenlauf_FL1(:) = 1/2*(axiL1(:)-byiL1(:)+1j*(ayiL1(:)+bxiL1(:)));
Gleichlauf_FL2(:) = 1/2*(axiL2(:)+byiL2(:)+1j*(ayiL2(:)-bxiL2(:)));
Gegenlauf_FL2(:) = 1/2*(axiL2(:)-byiL2(:)+1j*(ayiL2(:)+bxiL2(:)));


end
