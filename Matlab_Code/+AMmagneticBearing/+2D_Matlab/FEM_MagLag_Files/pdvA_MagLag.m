function [ Kraefte, Energien, GitterZellenArray ] = pdvA_MagLag( Position, Verschiebeweg, SpulenStrom)
%   Name: PDVA_MagLag.m

%   Beschreibung: Ermittelt mittels Prinzip der virtuellen Arbeit

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE

%   Benoetigte Skripten/Funktionen: Geometrie_MagLag.m,
%%%%%%%%%%%%%

global debugMode varMu plotGeometry plotMesh plotVektorPot  % Globale Variablen dienen als Schalter

    %%%%%%%%%%%%% TO DO / VERBESSERUNGEN
    %1) nicht-lineares Mu
    %2) wenn Verschiebung fest steht wird die Matrix Verschiebeweg auch in
    %Fkt BerechneVerschiebung ... erstellt
    %%%%%%%%%%%%%% ENDE TO DO

GitterZellenArray=zeros(1,3);                
  
% [Verschiebeweg]=BerechneVerschiebung_MagLag(Position);         % Verschieberichtung in Abhaengigkeit der Wellenposition

VerschiebewegMat=[0 0; Verschiebeweg(1) 0; 0 Verschiebeweg(2)];            % Wertepaare fuer Verschiebung // am Ende mit BerechneVerschiebung_MagLag zusammenlegen
WMat=zeros(3,1);
WNonLinMat=zeros(3,1);

for i=1:3           % drei Simulationen fuer Prinzip der virtuellen Verschiebung
    
    if debugMode
        fprintf('\nBeginn %i. von %i Simulationen \n', i+(varMu*(i-1)), 3*(1+varMu));
    
    end
        
    [W,A, K,model,GitterZellen]=FEM_MagLag(Position, VerschiebewegMat(i,:),SpulenStrom,0,0);     % FEM-Simulation mit konstanter Permeabilitaet des Eisens (erste Null); keine K-Matrix (zweite Null)
    WMat(i)=W;
    GitterZellenArray(i)=GitterZellen;
    if plotGeometry || plotMesh || plotVektorPot
        Plots_MagLag
    end
    
    if varMu
        if debugMode
            fprintf('\nBeginn %i. von %i Simulationen \n', i+1+(varMu*(i-1)), 3*(1+varMu));
        end
        [WNonLin, A,~,model]=FEM_MagLag(Position,VerschiebewegMat(i,:),SpulenStrom,1,K);  % Zusaetzlich FEM-Simulation mit nichtlinearer Permeabilitaet      
        WNonLinMat(i)=WNonLin; 
        if plotGeometry || plotMesh || plotVektorPot
            Plots_MagLag
        end
    end    
end    

[~,~,~,~,~,dTiefe]=Stoffwerte_MagLag();     % Tiefe des Magnetlagers 

if varMu
    Kraefte(1)=(WNonLinMat(2)-WNonLinMat(1))*dTiefe/Verschiebeweg(1);       
    Kraefte(2)=(WNonLinMat(3)-WNonLinMat(1))*dTiefe/Verschiebeweg(2);
    Energien=WNonLinMat;
else
    Kraefte(1)=(WMat(2)-WMat(1))*dTiefe/Verschiebeweg(1);       
    Kraefte(2)=(WMat(3)-WMat(1))*dTiefe/Verschiebeweg(2);
    Energien=WMat;
end
    
end

