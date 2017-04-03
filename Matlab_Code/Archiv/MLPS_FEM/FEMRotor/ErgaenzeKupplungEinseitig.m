function [K_Kup, EI, l] = ErgaenzeKupplungEinseitig(Knoten,zPos,kxy,l)

K_Kup = zeros(4*length(Knoten), 4*length(Knoten));

n0 = find(Knoten == zPos);
if length(n0) ~= 1
    error('Kupplung sitzt nicht an Knoten');
end

n0=2*n0; %dof-Nummer ist 2*Knotennummer

EI = kxy*l^3/12;

K_Kup(n0-1:n0,n0-1:n0) = EI * [ 12/l^3, 6/l^2;
                                6/l^2, 4/l];
                           
n0 = n0+2*length(Knoten);
K_Kup(n0-1:n0,n0-1:n0) = EI* [ 12/l^3, -6/l^2;
                               -6/l^2, 4/l];

% K_Kup(n0-1:n0,n0-1:n0) = [ kxy, l;
%                            l, 0];
%                            
% n0 = n0+2*length(Knoten);
% K_Kup(n0-1:n0,n0-1:n0) = EI* [ kxy, l;
%                                l, 0];
% 
% K_Test = EI * [ 12/l^3, 6/l^2, -12/l^3, 6/l^2;
%                 6/l^2, 4/l, -6/l^2, 2/l;
%                 -12/l^3, -6/l^2, 12/l^3, -6/l^2;
%                 6/l^2, 2/l, -6/l^2, 4/l];