function [DrehzahlMess,OmegaExakt,Gleichlauf_FGL,Gegenlauf_FGL, Gleichlauf_FWL, Gegenlauf_FWL] = AnalysiereEO_3SensorenJM_v04(data)

%Einlesen der Daten

Zeit=data(1,:);
Tacho = data(4,:); %Drehzahl [1/min]
phi = data(5,:);   %Winkel [°]

data_Kraft_GL_1=data(7,:); %Kraft in [N]
data_Kraft_GL_2=data(8,:);

data_Kraft_WL_1=data(9,:); %Kraft in [N]
data_Kraft_WL_2=data(10,:);

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
FGL_x_res=zeros(1,length(Zeit));
FGL_y_res=zeros(1,length(Zeit));
FWL_x_res=zeros(1,length(Zeit));
FWL_y_res=zeros(1,length(Zeit));

FGL_x_res(:)=0.5*sqrt(2)*(data_Kraft_GL_1(:)-data_Kraft_GL_2(:));
FGL_y_res(:)=0.5*sqrt(2)*(data_Kraft_GL_1(:)+data_Kraft_GL_2(:));
FWL_x_res(:)=0.5*sqrt(2)*(data_Kraft_WL_1(:)-data_Kraft_WL_2(:));
FWL_y_res(:)=0.5*sqrt(2)*(data_Kraft_WL_1(:)+data_Kraft_WL_2(:));

%% Fitting der Kräfte mit Fourierreihe

%Gleitlagerung
%--------------------------------------------------------------------------
%Kraft in x-Richtung
Ampl=zeros(8,4); %Matrix der Amplituden der Messdaten
Phase=zeros(8,4); %Matrix der Phasen der Messdaten (bezogen auf 0 Grad Rotordrehung)
fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,0.8*DrehzahlMess*pi/30],'Upper',[Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,1.2*DrehzahlMess*pi/30],'Startpoint',[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,DrehzahlMess*pi/30]);


RGLX = fit(Zeit.',FGL_x_res.', fittype('fourier8'),fo);
if abs(RGLX.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung Gleitlager')
end
Offset_GLX(1) = RGLX.a0;
Ampl(1:8,1) = [sqrt(RGLX.a1^2+RGLX.b1^2);
                sqrt(RGLX.a2^2+RGLX.b2^2);
                sqrt(RGLX.a3^2+RGLX.b3^2);
                sqrt(RGLX.a4^2+RGLX.b4^2);
                sqrt(RGLX.a5^2+RGLX.b5^2);
                sqrt(RGLX.a6^2+RGLX.b6^2);
                sqrt(RGLX.a7^2+RGLX.b7^2);
                sqrt(RGLX.a8^2+RGLX.b8^2)];
Phase(1:8,1) = [1*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b1,RGLX.a1);
                2*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b2,RGLX.a2);
                3*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b3,RGLX.a3);
                4*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b4,RGLX.a4);
                5*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b5,RGLX.a5);
                6*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b6,RGLX.a6);
                7*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b7,RGLX.a7);
                8*RGLX.w*ZeitNulldurchgang+atan2(-RGLX.b8,RGLX.a8)];

%Kraft in y-Richtung

RGLY = fit(Zeit.',FGL_y_res.', fittype('fourier8'),fo);
if abs(RGLX.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung Gleitlager')
end
Offset_GLY(1) = RGLY.a0;
Ampl(1:8,2) = [sqrt(RGLY.a1^2+RGLY.b1^2);
                sqrt(RGLY.a2^2+RGLY.b2^2);
                sqrt(RGLY.a3^2+RGLY.b3^2);
                sqrt(RGLY.a4^2+RGLY.b4^2);
                sqrt(RGLY.a5^2+RGLY.b5^2);
                sqrt(RGLY.a6^2+RGLY.b6^2);
                sqrt(RGLY.a7^2+RGLY.b7^2);
                sqrt(RGLY.a8^2+RGLY.b8^2)];
Phase(1:8,2) = [1*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b1,RGLY.a1);
                2*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b2,RGLY.a2);
                3*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b3,RGLY.a3);
                4*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b4,RGLY.a4);
                5*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b5,RGLY.a5);
                6*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b6,RGLY.a6);
                7*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b7,RGLY.a7);
                8*RGLY.w*ZeitNulldurchgang+atan2(-RGLY.b8,RGLY.a8)];

%Wälzlagerung
%--------------------------------------------------------------------------
%Kraft in x-Richtung
RWLX = fit(Zeit.',FWL_x_res.', fittype('fourier8'),fo);
if abs(RWLX.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung Gleitlager')
end
Offset_WLX(1) = RWLX.a0;
Ampl(1:8,3) = [sqrt(RWLX.a1^2+RWLX.b1^2);
                sqrt(RWLX.a2^2+RWLX.b2^2);
                sqrt(RWLX.a3^2+RWLX.b3^2);
                sqrt(RWLX.a4^2+RWLX.b4^2);
                sqrt(RWLX.a5^2+RWLX.b5^2);
                sqrt(RWLX.a6^2+RWLX.b6^2);
                sqrt(RWLX.a7^2+RWLX.b7^2);
                sqrt(RWLX.a8^2+RWLX.b8^2)];
Phase(1:8,3) = [1*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b1,RWLX.a1);
                2*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b2,RWLX.a2);
                3*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b3,RWLX.a3);
                4*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b4,RWLX.a4);
                5*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b5,RWLX.a5);
                6*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b6,RWLX.a6);
                7*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b7,RWLX.a7);
                8*RWLX.w*ZeitNulldurchgang+atan2(-RWLX.b8,RWLX.a8)];

%Kraft in y-Richtung

RWLY = fit(Zeit.',FWL_y_res.', fittype('fourier8'),fo);
if abs(RWLX.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung Gleitlager')
end
Offset_WLY(1) = RWLY.a0;
Ampl(1:8,4) = [sqrt(RWLY.a1^2+RWLY.b1^2);
                sqrt(RWLY.a2^2+RWLY.b2^2);
                sqrt(RWLY.a3^2+RWLY.b3^2);
                sqrt(RWLY.a4^2+RWLY.b4^2);
                sqrt(RWLY.a5^2+RWLY.b5^2);
                sqrt(RWLY.a6^2+RWLY.b6^2);
                sqrt(RWLY.a7^2+RWLY.b7^2);
                sqrt(RWLY.a8^2+RWLY.b8^2)];
Phase(1:8,4) = [1*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b1,RWLY.a1);
                2*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b2,RWLY.a2);
                3*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b3,RWLY.a3);
                4*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b4,RWLY.a4);
                5*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b5,RWLY.a5);
                6*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b6,RWLY.a6);
                7*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b7,RWLY.a7);
                8*RWLY.w*ZeitNulldurchgang+atan2(-RWLY.b8,RWLY.a8)];
            
            
%Gleichlauf und Gegenlauf
%--------------------------------------------------------------------------

Gleichlauf_FGL = linspace(0,0,8);
Gegenlauf_FGL = linspace(0,0,8);
Gleichlauf_FWL = linspace(0,0,8);
Gegenlauf_FWL = linspace(0,0,8);

axiGL=[RGLX.a1;RGLX.a2;RGLX.a3;RGLX.a4;RGLX.a5;RGLX.a6;RGLX.a7;RGLX.a8];
bxiGL=[RGLX.b1;RGLX.b2;RGLX.b3;RGLX.b4;RGLX.b5;RGLX.b6;RGLX.b7;RGLX.b8];
ayiGL=[RGLY.a1;RGLY.a2;RGLY.a3;RGLY.a4;RGLY.a5;RGLY.a6;RGLY.a7;RGLY.a8];
byiGL=[RGLY.b1;RGLY.b2;RGLY.b3;RGLY.b4;RGLY.b5;RGLY.b6;RGLY.b7;RGLY.b8];


axiWL=[RWLX.a1;RWLX.a2;RWLX.a3;RWLX.a4;RWLX.a5;RWLX.a6;RWLX.a7;RWLX.a8];
bxiWL=[RWLX.b1;RWLX.b2;RWLX.b3;RWLX.b4;RWLX.b5;RWLX.b6;RWLX.b7;RWLX.b8];
ayiWL=[RWLY.a1;RWLY.a2;RWLY.a3;RWLY.a4;RWLY.a5;RWLY.a6;RWLY.a7;RWLY.a8];
byiWL=[RWLY.b1;RWLY.b2;RWLY.b3;RWLY.b4;RWLY.b5;RWLY.b6;RWLY.b7;RWLY.b8];

Gleichlauf_FGL(:) = 1/2*(axiGL(:)+byiGL(:)+1j*(ayiGL(:)-bxiGL(:)));
Gegenlauf_FGL(:) = 1/2*(axiGL(:)-byiGL(:)+1j*(ayiGL(:)+bxiGL(:)));
Gleichlauf_FWL(:) = 1/2*(axiWL(:)+byiWL(:)+1j*(ayiWL(:)-bxiWL(:)));
Gegenlauf_FWL(:) = 1/2*(axiWL(:)-byiWL(:)+1j*(ayiWL(:)+bxiWL(:)));


% %Berechnung des Gleichlaufanteils und Gegenlaufanteils
% %Schreibe in Vektor, sortiert nach Ordnung der Fourierreihe
% FX_res_GL=zeros(1,8);
% FX_res_GG=zeros(1,8);
% for m=1:1:8
%     FX_res_GL(1,m)=0.5*sqrt(Fourier(m,1)^2+Fourier(m,2)^2)*exp(-1j*Phase(m));
%     FX_res_GG(1,m)=0.5*sqrt(Fourier(m,1)^2+Fourier(m,2)^2)*exp(1j*Phase(m));
% end


%Plot der Kraftdaten
% figure;
% plot(data_Kraft_GL_1(1:1:500)-mean(data_Kraft_GL_1(1:1:500)));
% hold all;
% plot(FGL_x_res(1:1:500)-mean(FGL_x_res(1:1:500)));
% plot(data_Kraft_GL_2(1:1:500)-mean(data_Kraft_GL_2(1:1:500)));
% plot(FGL_y_res(1:1:500)-mean(FGL_y_res(1:1:500)));
% title('Gemessene Kraftwerte Gleitlager genullt');
% xlabel('Zeit [s]');
% ylabel('Kraft [N]');
% legend('Lager1','Projektion auf x-Richtung', 'Lager2', 'Projektion auf y-Richtung');

 

