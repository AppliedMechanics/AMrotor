function Knoten = Erstelle_Vernetzung(Geometrie, dz)

Dim = size(Geometrie);
Knoten = Geometrie(1,1);

for n = 1:Dim(1)-1
    
    nAbschnitt = ceil((Geometrie(n+1,1)-Geometrie(n,1))/dz); %Anzahl der Knoten auf Abschnitt
    z = linspace(Geometrie(n,1), Geometrie(n+1,1), nAbschnitt+1); % Stuetzpunkte num. Integration, Maximalabstand dz
    Knoten = [Knoten, z(2:end)]; %#ok<AGROW>
    
end