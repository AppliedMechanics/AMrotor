function [Geometrie2, V, JzzNorm] = BerechneFlaechenmomente_Hohlwelle(Geometrie)

% Welle sei ideal kreisrund

Dim = size(Geometrie);
Geometrie2 = zeros(Dim(1), 4);
V = 0;
JzzNorm = 0; % int r^2 dV, entspricht J auf Einheitsdichte normiert 

for n = 1:Dim(1)-1
    Geometrie2(n,1) = pi*(Geometrie(n,2)^2-Geometrie(n,3)^2); % Flaeche
    Geometrie2(n,2) = pi*(Geometrie(n,2)^4/4-Geometrie(n,3)^4/4); % I_xi
    Geometrie2(n,3) = Geometrie2(n,2); % I_eta, bei Kreisquerschnitt gilt I_eta=I_xi
    Geometrie2(n,4) = Geometrie2(n,2) + Geometrie2(n,3); % I_p=I_xi+I_eta, gilt allgemein im Hauptachsensystem
    V = V + Geometrie2(n,1)*(Geometrie(n+1,1)-Geometrie(n,1));
    JzzNorm = JzzNorm + Geometrie2(n,4)*(Geometrie(n+1,1)-Geometrie(n,1));
end