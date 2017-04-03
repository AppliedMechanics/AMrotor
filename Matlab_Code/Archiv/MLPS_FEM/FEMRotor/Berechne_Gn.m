function Gn = Berechne_Gn(Geometrie, Flaechentraegheit, rho, Knoten)

Dim = size(Geometrie);
nKnoten = length(Knoten);

Gn = zeros(4*nKnoten, 4*nKnoten);

for n = 1:Dim(1)-1
    
    % Suche nach Knoten, die zu jeweiligen Abschnitt gehoeren
    n1=1;
    while Geometrie(n,1) > Knoten(n1)
        n1 = n1+1;
    end
    assert(Geometrie(n,1)==Knoten(n1),'Kein Knoten an Unstetigkeit');
    nStart = n1;
    
    while Geometrie(n+1,1) > Knoten(n1)
        n1 = n1+1;
    end
    assert(Geometrie(n+1,1)==Knoten(n1),'Kein Knoten an Unstetigkeit');
    nEnd = n1;
    
    for n1 = nStart:nEnd-1 % Assemblieren der Steifigkeitsmatrix
        [Gn_el1, Gn_el2] = Berechne_Gn_El(Knoten(n1+1)-Knoten(n1), rho, Flaechentraegheit(n,:)); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        z3 = nKnoten*2+n1*2-1;
        z4 = nKnoten*2+n1*2+2;
        
        Gn(z1:z2,z3:z4) = Gn(z1:z2,z3:z4) + Gn_el1(:,:);
        Gn(z3:z4,z1:z2) = Gn(z3:z4,z1:z2) + Gn_el2(:,:);
    end
end


function [Gn_el1, Gn_el2] = Berechne_Gn_El(l_Ele, rho, Flaechentraegheit)


% Rueckwirkung von yz auf xz
Gn_el1 = rho*Flaechentraegheit(4) *...
            [ 6/5/l_Ele, -1/10, -6/5/l_Ele, -1/10;
              1/10, -2/15*l_Ele, -1/10, 1/30*l_Ele;
             -6/5/l_Ele, 1/10, 6/5/l_Ele, 1/10;
             1/10, 1/30*l_Ele, -1/10, -2/15*l_Ele ];             

% Rueckwirkung von xz auf yz
Gn_el2 = -rho*Flaechentraegheit(4) * ...
            [ 6/5/l_Ele, 1/10, -6/5/l_Ele, 1/10;
              -1/10, -2/15*l_Ele, 1/10, 1/30*l_Ele;
              -6/5/l_Ele, -1/10, 6/5/l_Ele, -1/10;
              -1/10, 1/30*l_Ele, 1/10, -2/15*l_Ele];
                     
