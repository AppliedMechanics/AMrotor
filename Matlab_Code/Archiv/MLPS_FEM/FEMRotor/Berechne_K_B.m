function K_B = Berechne_K_B(Geometrie, Flaechentraegheit, E, Knoten)

Dim = size(Geometrie);
nKnoten = length(Knoten);

K_B = sparse(4*nKnoten, 4*nKnoten);

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
        [K_B_el1, K_B_el2] = Berechne_K_B_El(Knoten(n1+1)-Knoten(n1), E, Flaechentraegheit(n,:)); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        K_B(z1:z2,z1:z2) = K_B(z1:z2,z1:z2) + K_B_el1(:,:);
        z1 = nKnoten*2+n1*2-1;
        z2 = nKnoten*2+n1*2+2;
        K_B(z1:z2,z1:z2) = K_B(z1:z2,z1:z2) + K_B_el2(:,:);
    end
end


function [K_B_el1, K_B_el2] = Berechne_K_B_El(l_Ele, E, Flaechentraegheit)

assert(Flaechentraegheit(2) == Flaechentraegheit(3))

% xz-Ebene: translatorischer und rotatorischer Anteil
K_B_el1 = E*Flaechentraegheit(3) * [ 12/l_Ele^3, 6/l_Ele^2, -12/l_Ele^3, 6/l_Ele^2;
                                     6/l_Ele^2, 4/l_Ele, -6/l_Ele^2, 2/l_Ele;
                                     -12/l_Ele^3, -6/l_Ele^2, 12/l_Ele^3, -6/l_Ele^2;
                                     6/l_Ele^2, 2/l_Ele, -6/l_Ele^2, 4/l_Ele]; %Biegung xz-Ebene
K_B_el2 = E*Flaechentraegheit(2) * [ 12/l_Ele^3, -6/l_Ele^2, -12/l_Ele^3, -6/l_Ele^2;
                                     -6/l_Ele^2, 4/l_Ele, 6/l_Ele^2, 2/l_Ele;
                                     -12/l_Ele^3, 6/l_Ele^2, 12/l_Ele^3, 6/l_Ele^2;
                                     -6/l_Ele^2, 2/l_Ele, 6/l_Ele^2, 4/l_Ele]; %Biegung yz-Ebene
                     
