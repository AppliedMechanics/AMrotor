function nodes = meshing(rotorpar)

Dim = size(rotorpar.rotor_dimensions);
nodes = rotorpar.rotor_dimensions(1,1);

for n = 1:Dim(1)-1
    
    nAbschnitt = ceil((rotorpar.rotor_dimensions(n+1,1)-rotorpar.rotor_dimensions(n,1))/rotorpar.dz); %Anzahl der Knoten auf Abschnitt
    z = linspace(rotorpar.rotor_dimensions(n,1), rotorpar.rotor_dimensions(n+1,1), nAbschnitt+1); % Stuetzpunkte num. Integration, Maximalabstand dz
    nodes = [nodes, z(2:end)]; %#ok<AGROW>
    
end