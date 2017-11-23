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
        error('You choose an option which is not implemented yet!')
end
    
indices = start:ende;
M = obj.rotorsystem.systemmatrizen.M(indices,indices);
K = obj.rotorsystem.systemmatrizen.K(indices,indices);
[V,tmp] = eigs(-K,M,nModes,'sm');
[D,order] = sort(sqrt(diag(tmp)));
% sorting
for i = 1:length(order)
    tmp = V(:,i);
    V(:,i) = V(:,order(i));
    V(:,order(i)) = tmp;
end
end

