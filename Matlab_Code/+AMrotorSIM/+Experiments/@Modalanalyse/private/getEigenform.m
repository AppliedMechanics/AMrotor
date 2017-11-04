function [ V, D ] = getEigenform( obj, nModes, selection )
%GETEIGENFORM Summary of this function goes here
%   Berechnet die Eigenformen der ausgewaehlten Koordinatenrichtung. Die
%   Eigenwerte werden gleich als sqrt(...) und der Groesse
%   nach aufsteigend zurueck gegeben.
[row,~] = size(obj.rotorsystem.systemmatrizen.M);
switch selection
    case 'x'
        start = 1;
        ende  = row/2;
    case 'y'
        start = row/2+1;
        ende  = row;
    otherwise
        a = dbstack;
        errorMessage = sprintf(...
              "Das ist keine valide Auswahl fuer die Berechnung der Eigenformen!\n" + ...
              "Fehler tritt in der Datei %s in der Zeile %1.0f auf.\n" + ...
              "Der fehlerhafter Aufruf kommt aus %s mit Zeile %1.0f",...
              a(1).file,a(1).line,a(2).file,a(2).line);
        error(char(errorMessage))
end
    
indices = start:ende;
M = obj.rotorsystem.systemmatrizen.M(indices,indices);
K = obj.rotorsystem.systemmatrizen.K(indices,indices);
[V,tmp] = eigs(K,M,nModes,'sm');
[D,order] = sort(sqrt(diag(tmp)));
% sorting
for i = 1:length(order)
    tmp = V(:,i);
    V(:,i) = V(:,order(i));
    V(:,order(i)) = tmp;
end
end

