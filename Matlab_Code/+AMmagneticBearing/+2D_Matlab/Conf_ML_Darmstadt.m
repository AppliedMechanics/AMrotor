function config=Conf_ML_Darmstadt()
%   Beschreibung: Erzeugt die Geometrie des Magnetlagers  

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Stoffwerte_MagLag.m, Init_MagLag.m, Solve_MagLag.m, (SolveNonLin_MagLag.m)

%% Definition der Geometrie (in Metern)
cnfg.name='Darmstadt';

dLagerringAussen=140*1E-3;              
dLagerringInnen=118*1E-3;
sysGrenze=dLagerringAussen/2+10*1e-3;   % Abstand vom Lagerring zur Systemgrenze
dBohrung=57.6*1E-3;

bPol=10*1E-3;               % Breite des Pols
bPolFuss=12.3*1E-3;         % Breite des Pols an der Ausbauchung
alpha1=22.5;                % Verdrehung des ersten Pols zur Y-Achse
ausbauchung=3*1E-3;         % Ausbauchung der Wicklung
dRB1=56*1E-3;               % Aussendurchmesser der Rotorbuechse (Welle)
dRB2=15*1E-3;               % Innendurchmesser der Rotorbuechse

%% KREISE
LR1=[1, 0, 0, dLagerringAussen/2]';                                        % aeussere Berandung des Lagerrings
LR2=[1, 0, 0, dLagerringInnen/2]';                                         % innere Berandung
RB1=[1,0,0,dRB1/2]';   % Aussendurchmesser Rotorb�chse
RB2=[1,0,0,dRB2/2]';   % Innendurchmesser Rotorb�chse
RBH=[1,0,0,((dRB1)/2)-2e-4]';   % Hilfskreis auf Rotorb�chse
sG=[3, 4, sysGrenze*[-1, 1, 1, -1, -1, -1, 1, 1]]';                        % Systemgrenze

%% POLE: hier werden die Eckpunkte eines Pols definiert
xP1=bPolFuss/2-(0.0305-dBohrung/2)*sind(alpha1);
yP1=sqrt((dBohrung/2)^2-xP1^2);
xP2=-xP1;
yP2=yP1;
xP3=bPolFuss/2;
yP3=sqrt((0.0305)^2-xP3^2);
xP4=-xP3;
yP4=yP3;
xP5=bPol/2;
yP5=yP3+sqrt(0.004^2-(bPolFuss/2-0.010/2)^2);
xP6=-xP5;
yP6=yP5;
xP7=bPol/2;
yP7=sqrt(((dLagerringInnen/2))^2-(bPol/2)^2)-0.004;
xP8=-xP7;
yP8=yP7;
xP9=bPol/2+0.004;
yP9=sqrt((0.118/2)^2-(bPol/2+0.004)^2);
xP10=-xP9;
yP10=yP9;
xP11=0.8*bPolFuss/2;
yP11=0.028376;
xP12=-xP11;
yP12=yP11;
xP13=0.6*bPolFuss/2;
yP13=0.0285625;
xP14=-xP13;
yP14=yP13;
xP15=0.4*bPolFuss/2;
yP15=0.0286945;
xP16=-xP15;
yP16=yP15;
xP17=0.2*bPolFuss/2;
yP17=0.02877368;
xP18=-xP17;
yP18=yP17;
xP19=0;
yP19=0.0288;

pktePole=[xP1 yP1; xP3 yP3; xP5 yP5; xP7 yP7; xP9 yP9; xP10 yP10; xP8 yP8; xP6 yP6; xP4 yP4; xP2 yP2; xP12 yP12; ...
 xP14 yP14; xP16 yP16; xP18 yP18; xP19 yP19; xP17 yP17; xP15 yP15; xP13 yP13; xP11 yP11 ];     % Darstellung des ersten Pols (Reihenfolge der Punkte ist wichtig!)

%% Spulen
wb=0.008;
yS1=sqrt((dLagerringInnen/2)^2-(bPol/2+wb/2)^2);
yS2=yS1-yP7;
xS96=bPol/2+wb/2;
yS96=yP5-yS2;
xS97=bPol/2+wb;
yS97=yP5;
xS98=xS97;
yS98=yP7;
xS99=xS96;
yS99=yS1;
xS100=-xS96;
yS100=yS96;
xS101=-xS97;
yS101=yS97;
xS102=-xS97;
yS102=yS98;
xS103=-xS96;
yS103=yS99;

xS160=xS97+ausbauchung;
yS160=(yP5+yP7)/2;
xS161=-xS160;
yS161=yS160;

pkteSpuleRe=[xS96 yS96; xS97 yS97;  xS160 yS160; xS98 yS98;  xS99 yS99; xP7 yP7; xP5 yP5];                      % Darstellung der ersten (rechten) Spulenh�lfte
pkteSpuleLi=[xS100 yS100; xS101 yS101; xS161 yS161; xS102 yS102; xS103 yS103; xP8 yP8; xP6 yP6];

%% Rotieren und Kopieren der Pole und Spulen
alpha=22.5;
pktePoleRot=zeros(length(pktePole),2,8);          % Matrix fuer alle (durch Rotation erzeugten) Pole
pkteSpuleReRot=zeros(length(pkteSpuleRe),2,8);    % ... fuer die rechten Spulenhaelften
pkteSpuleLiRot=zeros(length(pkteSpuleLi),2,8);    % ... fuer die linken Spulenhaelften

csgPole=zeros(2*length(pktePole)+2,8);            % leere Matrix fuer CSG-Formulierung der Pole
csgSpuleRe=zeros(2*length(pkteSpuleRe)+2,8);
csgSpuleLi=zeros(2*length(pkteSpuleLi)+2,8);
for i=1:size(pktePoleRot,3)
    rotMat=[cosd(-alpha) -sind(-alpha);sind(-alpha) cosd(-alpha)];  % Drehmatrix
    pktePoleRot(:,:,i)=pktePole*rotMat;
    pkteSpuleReRot(:,:,i)=pkteSpuleRe*rotMat;
    pkteSpuleLiRot(:,:,i)=pkteSpuleLi*rotMat;
    csgPole(:,i)=[3,length(pktePole),pktePoleRot(1:end,1,i)',pktePoleRot(1:end,2,i)']';
    csgSpuleRe(:,i)=[3, length(pkteSpuleRe), pkteSpuleReRot(1:end,1,i)',pkteSpuleReRot(1:end,2,i)']';
    csgSpuleLi(:,i)=[3, length(pkteSpuleLi), pkteSpuleLiRot(1:end,1,i)',pkteSpuleLiRot(1:end,2,i)']';
    alpha=alpha+45;
end

LR1 = [LR1;zeros(length(csgPole(:,1)) - length(LR1),1)];     % Auffuellen der angelegten Matrizen mit Nullen
LR2 = [LR2;zeros(length(csgPole(:,1)) - length(LR2),1)];     % (alle Arrays bzw. Matrizen muessen gleich lang sein)
RB2 = [RB2;zeros(length(csgPole(:,1)) - length(RB2),1)]; 
RB1 = [RB1;zeros(length(csgPole(:,1)) - length(RB1),1)]; 
RBH = [RBH;zeros(length(csgPole(:,1)) - length(RBH),1)]; 
sG=[sG;zeros(length(csgPole(:,1))-length(sG),1)];
csgSpuleRe=[csgSpuleRe; zeros(length(csgPole)-length(csgSpuleRe),size(csgSpuleRe,2))];
csgSpuleLi=[csgSpuleLi; zeros(length(csgPole)-length(csgSpuleLi),size(csgSpuleLi,2))];


gm=[sG,RB1,RBH,RB2,LR1,LR2,csgPole(:,1:8),csgSpuleRe(:,1:8),csgSpuleLi(:,1:8)];                   % Geometrie besteht aus den genannten Elementen
ns=(char('SystemGrenze','Rotorbuechse','RBH','RB2','LR1','LR2','P1','P2','P3','P4','P5','P6','P7', ...        % Zuweisung der Namen          
    'P8','SR1','SR2','SR3','SR4','SR5','SR6','SR7','SR8','SL1','SL2','SL3','SL4','SL5','SL6','SL7','SL8'))'; 
sf='Rotorbuechse+RBH+LR1-LR2+SystemGrenze+(P1+P2+P3+P4+P5+P6+P7+P8)-RB2+(SR1+SR2+SR3+SR4+SR5+SR6+SR7+SR8)+(SL1+SL2+SL3+SL4+SL5+SL6+SL7+SL8)'; % Setzen der Formel, wie die Koerper zusammenspielen

[dl,bt]=decsg(gm,sf,ns);                       % Erzeugen der Geometrie 

zaehler=1;
KantenDel=zeros(1,size(csgPole,2));      % es muessen pro Pol zwei Linien geloescht werden. 
tol=1*1E-5;
for i=size(dl,2):-1:1
    for j=1:size(csgPole,2)     % if-Schleife: wenn vorhandende Kante mit Start- und Endpunkt einer zu loeschenden Linie zusammenfaellt. If/Else wegen Umlaufrichtung der Kanten
        if( (abs(dl(2,i)-csgPole(7,j))<tol) && (abs(dl(3,i)-csgPole(8,j))<tol) && ((abs(dl(4,i)-csgPole(26,j))<tol)||(abs((dl(4,i)-csgPole(27,j)))<tol)))    % 5. und 6. Punkt in der CSG-Formulierung der Pole. Also Eintraege 7,8 (x) und 26,27 (y) in csgPole
            KantenDel(zaehler)=i;
            zaehler=zaehler+1;
          elseif( (abs(dl(2,i)-csgPole(8,j))<tol) && (abs(dl(3,i)-csgPole(7,j))<tol) && ((abs(dl(4,i)-csgPole(26,j))<tol)||(abs((dl(4,i)-csgPole(27,j)))<tol)))  
            KantenDel(zaehler)=i;
            zaehler=zaehler+1;                 
        end
    end
end
[dl,~]=csgdel(dl,bt,KantenDel);            % Loesche alle Kanten aus dem Array "KantenDel"
%% Geometrie in cnfg sichern
% Berechnung der Spulengroesse (wird fuer Ermittlung der Stromdichte
% benoetigt
cnfg.coil.area=0.5*( (xS96-xS97)*(yS96+yS97)+(xS97-xS160)*(yS97+yS160)+(xS160-xS98)*(yS160+yS98)+(xS98-xS99)* ...       
   (yS98+yS99)+(xS99-xP7)*(yS99+yP7)+(xP7-xP5)*(yP7+yP5)+(xP5-xS96)*(yP5+yS96))   ;   
cnfg.geometry.dl=dl;

%% Material 

     cnfg.material.nonlinMu =0;

% Permeabilit�t im Vakuum   
     cnfg.material.mu_0=4*pi*10^(-7);
    
% relative Permeabilitaeten
     cnfg.material.mu_rLuft=1+4E-7;
     cnfg.material.mu_rEisen=10000;
     cnfg.material.mu_rKupfer=1-6E-6;    

% Absolute Permeabilitaeten
     cnfg.material.mu_Luft =  cnfg.material.mu_rLuft* cnfg.material.mu_0; 
     cnfg.material.mu_Eisen =  cnfg.material.mu_rEisen* cnfg.material.mu_0;
     cnfg.material.mu_Kupfer =  cnfg.material.mu_rKupfer* cnfg.material.mu_0;

%% Geometriezuornungen
cnfg.faces.Luft=[1,16,19];
cnfg.faces.Eisen=[2,17,18]; % Alle Bauteile aus Eisen
cnfg.faces.Welle=[17,18,19]; % Fl�chen die sich mit der Welle bewegen
cnfg.faces.SpuleA_1=[3,22];
cnfg.faces.SpuleB_1=[4,11];
cnfg.faces.SpuleA_2=[5,20];
cnfg.faces.SpuleB_2=[21,6];
cnfg.faces.SpuleA_3=[7,12];
cnfg.faces.SpuleB_3=[8,15];
cnfg.faces.SpuleA_4=[9,14];
cnfg.faces.SpuleB_4=[10,13];

cnfg.edges.Dirichlet=[1,2,210,209];

cnfg.geometry.r_Welle=dRB1/2;
cnfg.geometry.r_Luftspalt_Aussen=dBohrung/2;
cnfg.coil.n_Windungen=104;
cnfg.geometry.dTiefe=0.032;

config=cnfg;
end
%% Fragen

%Spulenzuornungen