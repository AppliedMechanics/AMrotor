function [DrehzahlMess,OmegaExakt,Gleichlauf_FL1,Gegenlauf_FL1, Gleichlauf_FL2, Gegenlauf_FL2,StatischeKraft_FL1,StatischeKraft_FL2,fourier]=analyse_force_fourier_coeff(self,Zeit,Tacho,phi,data_Kraft_L1_1,data_Kraft_L1_2,data_Kraft_L2_1,data_Kraft_L2_2)
%Einlesen der Daten

% Zeit=data(1,:);
% Tacho = data(4,:); %Drehzahl [1/min]
% phi = data(5,:);   %Winkel [°]

% data_Kraft_L1_1=data(7,:); %Kraft in [N]
% data_Kraft_L1_2=data(8,:);

% data_Kraft_L2_1=data(9,:); %Kraft in [N]
% data_Kraft_L2_2=data(10,:);

% Messwinkel=[90,180]*pi/180;
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

%fo = fitoptions('poly1','Normalize','off', 'Robust', 'off');
%FitPhi = cfit(Zeit.',phi2.','poly1',fo);
%PlotFitPhi = FitPhi.p1*Zeit+FitPhi.p2;% Macht winkel
%PlotFitPhi=phi2;
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


%% Äquivalentes Ersetzen der gemessenen Kraftwerte durch Resultierende
FL1_x_res=zeros(1,length(Zeit));
FL1_y_res=zeros(1,length(Zeit));
FL2_x_res=zeros(1,length(Zeit));
FL2_y_res=zeros(1,length(Zeit));

FL1_x_res(:)=data_Kraft_L1_1(:);   %0.5*sqrt(2)*(data_Kraft_L1_1(:)-data_Kraft_L1_2(:));
FL1_y_res(:)=data_Kraft_L1_2(:);   %0.5*sqrt(2)*(data_Kraft_L1_1(:)+data_Kraft_L1_2(:));
FL2_x_res(:)=data_Kraft_L2_1(:);   %0.5*sqrt(2)*(data_Kraft_L2_1(:)-data_Kraft_L2_2(:));
FL2_y_res(:)=data_Kraft_L2_2(:);   %0.5*sqrt(2)*(data_Kraft_L2_1(:)+data_Kraft_L2_2(:));

%% Fitting der Kräfte mit Fourierreihe

% Rechung Lager 1
%--------------------------------------------------------------------------
%Kraft in x-Richtung
% Ampl=zeros(8,4); %Matrix der Amplituden der Messdaten
% Phase=zeros(8,4); %Matrix der Phasen der Messdaten (bezogen auf 0 Grad Rotordrehung)
fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower',[-Inf,-Inf,-Inf,0.8*DrehzahlMess*pi/30],'Upper',[Inf,Inf,Inf,1.2*DrehzahlMess*pi/30],'Startpoint',[0,0,0,DrehzahlMess*pi/30]);% Omega=DrehzahlMess*pi/30,  n[1/min]/60[s/min]*2*pi


RL1X = fit(Zeit.',FL1_x_res.', fittype('fourier1'),fo);
if abs(RL1X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung linkes Lager')
end
% Offset_L1X(1) = RL1X.a0;
% Ampl(1,1) = [sqrt(RL1X.a1^2+RL1X.b1^2)];
% Phase(1,1) = [1*RL1X.w*ZeitNulldurchgang+atan2(-RL1X.b1,RL1X.a1)];

%Kraft in y-Richtung

RL1Y = fit(Zeit.',FL1_y_res.', fittype('fourier1'),fo);
if abs(RL1X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung linkes lager')
end
% Offset_L1Y(1) = RL1Y.a0;
% Ampl(1,2) = [sqrt(RL1Y.a1^2+RL1Y.b1^2)];
% Phase(1,2) = [1*RL1Y.w*ZeitNulldurchgang+atan2(-RL1Y.b1,RL1Y.a1)];

%Rechnung Lager 2
%--------------------------------------------------------------------------
%Kraft in x-Richtung
RL2X = fit(Zeit.',FL2_x_res.', fittype('fourier1'),fo);
if abs(RL2X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei x-Richtung rechtes Lager')
end
% Offset_L2X(1) = RL2X.a0;
% Ampl(1,3) = [sqrt(RL2X.a1^2+RL2X.b1^2)];
% Phase(1,3) = [1*RL2X.w*ZeitNulldurchgang+atan2(-RL2X.b1,RL2X.a1)];

%Kraft in y-Richtung

RL2Y = fit(Zeit.',FL2_y_res.', fittype('fourier1'),fo);
if abs(RL2X.w-OmegaExakt)>1
    disp('Achtung: Fehler bei Frequenz der Fourierreihe bei y-Richtung rechtes Lager')
end
% Offset_L2Y(1) = RL2Y.a0;
% Ampl(1,4) = [sqrt(RL2Y.a1^2+RL2Y.b1^2)];
%                 
% Phase(1,4) = [1*RL2Y.w*ZeitNulldurchgang+atan2(-RL2Y.b1,RL2Y.a1)];
                
            
            
%Gleichlauf und Gegenlauf
%--------------------------------------------------------------------------

% Gleichlauf_FL1 = linspace(0,0,8);
% Gegenlauf_FL1 = linspace(0,0,8);
% Gleichlauf_FL2 = linspace(0,0,8);
% Gegenlauf_FL2 = linspace(0,0,8);

axiL1=[RL1X.a1];
bxiL1=[RL1X.b1];
ayiL1=[RL1Y.a1];
byiL1=[RL1Y.b1];


axiL2=[RL2X.a1];
bxiL2=[RL2X.b1];
ayiL2=[RL2Y.a1];
byiL2=[RL2Y.b1];

ax0L1=[RL1X.a0];
ay0L1=[RL1Y.a0];
ax0L2=[RL2X.a0];
ay0L2=[RL2Y.a0];

StatischeKraft_FL1(:) = ( ax0L1(:) + 1j*ay0L1(:) );
StatischeKraft_FL2(:) = ( ax0L2(:) + 1j*ay0L2(:) );
Gleichlauf_FL1(:) = 1/2*(axiL1(:)+byiL1(:)+1j*(ayiL1(:)-bxiL1(:)));
Gegenlauf_FL1(:) = 1/2*(axiL1(:)-byiL1(:)+1j*(ayiL1(:)+bxiL1(:)));
Gleichlauf_FL2(:) = 1/2*(axiL2(:)+byiL2(:)+1j*(ayiL2(:)-bxiL2(:)));
Gegenlauf_FL2(:) = 1/2*(axiL2(:)-byiL2(:)+1j*(ayiL2(:)+bxiL2(:)));

% figure
% hold on
% t=(0:0.001:1);
% plot(t,FL1_x_res)
% plot(t,RL1X.a1*cos(RL1X.w*t)+ RL1X.b1*sin(RL1X.w*t))
% hold off
fourier.x1=RL1X;
fourier.y1=RL1Y;
fourier.x2=RL2X;
fourier.y2=RL2Y;
fourier.Zeit=Zeit;
fourier.L1X=FL1_x_res;
fourier.L1Y=FL1_y_res;
fourier.L2X=FL2_x_res;
fourier.L2Y=FL2_y_res;
fourier.omega=DrehzahlMess*2*pi/60;
end
