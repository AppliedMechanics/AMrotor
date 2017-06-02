function M = Berechne_M(Geometrie, Flaechentraegheit, rho, Knoten)

Dim = size(Geometrie);
nKnoten = length(Knoten);

M = sparse(4*nKnoten, 4*nKnoten);

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
        [M_el1, M_el2] = Berechne_M_El(Knoten(n1+1)-Knoten(n1), rho, Flaechentraegheit(n,:)); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        M(z1:z2,z1:z2) = M(z1:z2,z1:z2) + M_el1(:,:);
        z1 = nKnoten*2+n1*2-1;
        z2 = nKnoten*2+n1*2+2;
        M(z1:z2,z1:z2) = M(z1:z2,z1:z2) + M_el2(:,:);
    end
end


function [M_el1, M_el2] = Berechne_M_El(l_Ele, rho, Flaechentraegheit)

assert(Flaechentraegheit(2) == Flaechentraegheit(3));

% xz-Ebene: translatorischer und rotatorischer Anteil
M_el1 = rho*Flaechentraegheit(1) * [ 13/35*l_Ele, 11/210*l_Ele^2, 9/70*l_Ele, -13/420*l_Ele^2;
                                     11/210*l_Ele^2, 1/105*l_Ele^3, 13/420*l_Ele^2, -1/140*l_Ele^3;
                                     9/70*l_Ele, 13/420*l_Ele^2, 13/35*l_Ele, -11/210*l_Ele^2;
                                     -13/420*l_Ele^2, -1/140*l_Ele^3, -11/210*l_Ele^2, 1/105*l_Ele^3 ] + ... 
        rho*Flaechentraegheit(3) * [ 6/5/l_Ele, 1/10, -6/5/l_Ele, 1/10;
                                     1/10, 2/15*l_Ele, -1/10, -1/30*l_Ele;
                                     -6/5/l_Ele, -1/10, 6/5/l_Ele, -1/10;
                                     1/10, -1/30*l_Ele, -1/10, 2/15*l_Ele ];             

% yz-Ebene: translatorischer und rotatorischer Anteil
M_el2 = rho*Flaechentraegheit(1) * [ 13/35*l_Ele, -11/210*l_Ele^2, 9/70*l_Ele, 13/420*l_Ele^2;
                                     -11/210*l_Ele^2, 1/105*l_Ele^3, -13/420*l_Ele^2, -1/140*l_Ele^3;
                                     9/70*l_Ele, -13/420*l_Ele^2, 13/35*l_Ele, 11/210*l_Ele^2;
                                     13/420*l_Ele^2, -1/140*l_Ele^3, 11/210*l_Ele^2, 1/105*l_Ele^3 ] + ...
        rho*Flaechentraegheit(2) * [ 6/5/l_Ele, -1/10, -6/5/l_Ele, -1/10;
                                     -1/10, 2/15*l_Ele, 1/10, -1/30*l_Ele;
                                     -6/5/l_Ele, 1/10, 6/5/l_Ele, 1/10;
                                     -1/10, -1/30*l_Ele, 1/10, 2/15*l_Ele ];
                     
