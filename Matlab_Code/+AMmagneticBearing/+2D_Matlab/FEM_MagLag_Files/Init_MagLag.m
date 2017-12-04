function [ model, GitterZellen ] = Init_MagLag(dl,bt,RB1,csgPole, ASpule, SpulenStrom,model, nonlinMu)
%   Name: Init_MagLag.m

%   Beschreibung: legt die Randbedingungen fest und definiert Koeffizienten
%   der pDGL

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Stoffwerte_MagLag.m, Geometrie_MagLag.m, Solve_MagLag.m, (SolveNonLin_MagLag.m)
%%%%%%%%%%%%%
global debugMode;               % globale Variable; dient als Schalter

if debugMode
   fprintf('Init_MagLag.m gestartet ... \n'); 
end

% Hole Stoff- und Geometriewerte
[mu_Luft,mu_Eisen,mu_Kupfer,mu_0, n_Windungen, dTiefe]=Stoffwerte_MagLag();     

%%%%%% PDE-Koeffizienten und Randbedingungen

% Kantennummern der Systemgrenze
KantenSG=zeros(1,4);
zaehler=1;
for i=1:size(dl,2)
   if ((dl(6,i)==0) || dl(7,i)==0)          % wenn Gebiet rechts oder links einer Kante die FlaechenID Null hat
   KantenSG(zaehler)=i;
   zaehler=zaehler+1;
   end
end

% Phasenzuweisung der Welle
zaehler=2;
FEisen=zeros(1,2);              % Es gibt zwei Eisenflaechen; Rotor und Stator
FEisen(1)=2;                    % Stator; ID ist immer gleich
for i=1:size(bt,1)              % Spalte 2 und 3 sind die beiden Geometrien (Eisen/Luft) des Rotors
    if (bt(i,3)==1)             % Bohrung in der Welle hat nur einen Eintrag, weil kleinster Koerper ohne Ueberschneidungen
        FLuft=[1,16,i];
    end
    if (bt(i,2)==1)&&bt(i,3)==0 % Eisenflaeche des Rotors besteht aus den Kreisen RB1 und RB2
         FEisen(zaehler)=i;     
         zaehler=zaehler+1;
    end
end

% Gruppieren der Spulen fuer Unterscheidung der Stromrichtung in den Spulen
% die zueinander zeigenden Teile des Querschnitts eines Spulenpaars Spulen werden als positiv bezeichnet
[FSpObenPos,FSpObenNeg, FSpRechtsPos, FSpRechtsNeg, FSpUntenPos, FSpUntenNeg, FSpLinksPos, FSpLinksNeg]=deal(zeros(1,2));       % leere Arrays fuer Phasennummern

tol=1*1E-5;                           % wegen Maschinengenauigkeit bei Formulierung der Edges
for i=size(dl,2):-1:1                 % Schleife ueber alle Edges
    
    % Oberes Polpaar
    if (abs(dl(2,i)-csgPole(9,1))<tol && abs(dl(4,i)-csgPole(28,1))<tol )           % SpulenQS links vom 1. Pol
        FSpObenNeg(1)=dl(7,i);

    elseif (abs(dl(3,i)-csgPole(6,8))<tol && abs(dl(5,i)-csgPole(25,8))<tol )      % SpulenQS rechts vom 8. Pol (gespiegelter Pol, deshalb 3. und 5. Eintrag in dl)
        FSpObenNeg(2)=dl(7,i);

    elseif (abs(dl(2,i)-csgPole(6,1))<tol && abs(dl(4,i)-csgPole(25,1))<tol )      % SpulenQS rechts vom 1. Pol
        FSpObenPos(1)=dl(7,i);

    elseif (abs(dl(3,i)-csgPole(9,8))<tol && abs(dl(5,i)-csgPole(28,8))<tol )      % SpulenQS links vom 8. Pol 
        FSpObenPos(2)=dl(7,i);
    
    % Linkes Polpaar
    elseif (abs(dl(3,i)-csgPole(9,2))<tol && abs(dl(5,i)-csgPole(28,2))<tol )           % SpulenQS links vom 2. Pol
        FSpLinksPos(1)=dl(7,i);

    elseif (abs(dl(2,i)-csgPole(6,3))<tol && abs(dl(4,i)-csgPole(25,3))<tol )      % SpulenQS rechts vom 3. Pol 
        FSpLinksPos(2)=dl(6,i);

    elseif (abs(dl(2,i)-csgPole(6,2))<tol && abs(dl(4,i)-csgPole(25,2))<tol )      % SpulenQS rechts vom 2. Pol
        FSpLinksNeg(1)=dl(6,i);

    elseif (abs(dl(3,i)-csgPole(9,3))<tol && abs(dl(5,i)-csgPole(28,3))<tol )      % SpulenQS links vom 3. Pol
        FSpLinksNeg(2)=dl(7,i);
    
        % Unteres Polpaar
    elseif (abs(dl(2,i)-csgPole(9,4))<tol && abs(dl(4,i)-csgPole(28,4))<tol )       % SpulenQS links vom 4. Pol
        FSpUntenPos(1)=dl(6,i);

    elseif (abs(dl(3,i)-csgPole(6,5))<tol && abs(dl(5,i)-csgPole(25,5))<tol )      % SpulenQS rechts vom 5. Pol 
        FSpUntenPos(2)=dl(6,i);

    elseif (abs(dl(2,i)-csgPole(6,4))<tol && abs(dl(4,i)-csgPole(25,4))<tol )      % SpulenQS rechts vom 4. Pol
        FSpUntenNeg(1)=dl(6,i);

    elseif (abs(dl(3,i)-csgPole(9,5))<tol && abs(dl(5,i)-csgPole(28,5))<tol )      % SpulenQS links vom 5. Pol
        FSpUntenNeg(2)=dl(6,i);
        
        % Rechtes Polpaar
    elseif (abs(dl(2,i)-csgPole(9,6))<tol && abs(dl(4,i)-csgPole(28,6))<tol )       % SpulenQS links vom 6. Pol
        FSpRechtsPos(1)=dl(6,i);

    elseif (abs(dl(3,i)-csgPole(6,7))<tol && abs(dl(5,i)-csgPole(25,7))<tol )      % SpulenQS rechts vom 7. Pol 
        FSpRechtsPos(2)=dl(7,i);

    elseif (abs(dl(2,i)-csgPole(6,6))<tol && abs(dl(4,i)-csgPole(25,6))<tol )      % SpulenQS rechts vom 6. Pol
        FSpRechtsNeg(1)=dl(7,i);

    elseif (abs(dl(3,i)-csgPole(9,7))<tol && abs(dl(5,i)-csgPole(28,7))<tol )      % SpulenQS links vom 7. Pol
        FSpRechtsNeg(2)=dl(6,i); 
    end

end
    
if debugMode
   fprintf('Pr�ge Randbedingung(en) auf ...  \n'); 
end

applyBoundaryCondition(model,'dirichlet','Edge',KantenSG,'r',0,'h',1); % Dirichlet-RB am Rand des Berechnungsgebietes

if debugMode
   fprintf('Weise PDE-Koeffizienten zu: \t'); 
end

% Koeffezienten der Eisenphase / Unterscheidung: nichtlinear oder lineares Model
if nonlinMu  
    cCoef = @(region,state) (mu_Eisen./(1+0.05*(state.ux.^2 +state.uy.^2))+200*mu_0);    % nicht konstanter Koeffizient C (Permeabilitaet)
%      cCoef = @(region,state) (5000./(1+0.05*(state.ux.^2+state.uy.^2))+200);
    specifyCoefficients(model,'m',0,'d',0,'c',cCoef,'a',0,'f',0,'Face',FEisen);       % Eisenkern und Rotorbuechse
    if debugMode
        fprintf('nicht-konstante Permeabilitaet fuer Eisen \n'); 
    end
else 
      specifyCoefficients(model,'m',0,'d',0,'c',1/(mu_Eisen),'a',0,'f',0,'Face',FEisen);       % Eisenkern und Rotorbuechse
      if debugMode
         fprintf('konstante Permeabilitaet fuer Eisen \n'); 
      end

end

% Koeffizienten fuer Luftphase
specifyCoefficients(model,'m',0,'d',0,'c',1/(mu_Luft),'a',0,'f',0,'Face',FLuft);         

% Koeffizienten fuer Spule
ArrayFSpPos=[FSpObenPos; FSpRechtsPos; FSpUntenPos; FSpLinksPos];
ArrayFSpNeg=[FSpObenNeg; FSpRechtsNeg; FSpUntenNeg; FSpLinksNeg];
   % Schleife ueber alle Spulenteile. Reihenfolge: oben, rechts, unten, links
    for j=1:size(ArrayFSpPos,1)
        specifyCoefficients(model,'m',0,'d',0,'c',1/(mu_Kupfer),'a',0,'f',n_Windungen*SpulenStrom(j)/ASpule,'Face',ArrayFSpPos(j,:)); % "Positive" Spulenteile
        specifyCoefficients(model,'m',0,'d',0,'c',1/(mu_Kupfer),'a',0,'f',-n_Windungen*SpulenStrom(j)/ASpule,'Face',ArrayFSpNeg(j,:)); % "Negative" Spulenteile
    end

%%%%% Erueigem des Netzes
if debugMode
   fprintf('Erzeuge Netz ...  \n'); 
end
generateMesh(model);
[p,e,t]=meshToPet(model.Mesh);                          % points, edges (die mit Koerperkante zusammenfallen), triangles
GitterZellen=size(t,2);

if debugMode
        fprintf('Netz mit %d Elementen erzeugt  \n', size(t,2));  
end
end

