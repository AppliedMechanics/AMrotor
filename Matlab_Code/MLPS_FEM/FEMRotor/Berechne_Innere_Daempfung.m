function [DDI, KDI] = Berechne_Innere_Daempfung(Geometrie, Flaechentraegheit, rho, E, alpha1, beta1, Knoten)

Dim = size(Geometrie);
nKnoten = length(Knoten);

DDI = zeros(4*nKnoten, 4*nKnoten);
KDI = DDI;

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
        [DDI_M_el1, DDI_M_el2, DDI_M_el3, DDI_M_el4] = Berechne_DDI_M_El(Knoten(n1+1)-Knoten(n1), rho, Flaechentraegheit(n,:)); %Elementsteifigkeitsmatrix
        [DDI_K_el1, DDI_K_el2, DDI_K_el3, DDI_K_el4] = Berechne_DDI_K_El(Knoten(n1+1)-Knoten(n1), E, Flaechentraegheit(n,:));
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        z3 = nKnoten*2+n1*2-1;
        z4 = nKnoten*2+n1*2+2;
        DDI(z1:z2,z1:z2) = DDI(z1:z2,z1:z2) + alpha1*DDI_M_el1(:,:) + beta1*DDI_K_el1(:,:);
        DDI(z3:z4,z3:z4) = DDI(z3:z4,z3:z4) + alpha1*DDI_M_el2(:,:) + beta1*DDI_K_el2(:,:);
        KDI(z1:z2,z3:z4) = KDI(z1:z2,z3:z4) + alpha1*DDI_M_el3(:,:) + beta1*DDI_K_el3(:,:);
        KDI(z3:z4,z1:z2) = KDI(z3:z4,z1:z2) + alpha1*DDI_M_el4(:,:) + beta1*DDI_K_el4(:,:);
    end
end

% Berechnung der masseproportionalen Matrizen

function [DDI_el1, DDI_el2, DDI_el3, DDI_el4] = Berechne_DDI_M_El(l_Ele, rho, Flaechentraegheit)

assert(Flaechentraegheit(2) == Flaechentraegheit(3));

% xz-Ebene: translatorischer und rotatorischer Anteil
DDI_el1 = rho*Flaechentraegheit(1) * [ 13/35*l_Ele, 11/210*l_Ele^2, 9/70*l_Ele, -13/420*l_Ele^2;
                                     11/210*l_Ele^2, 1/105*l_Ele^3, 13/420*l_Ele^2, -1/140*l_Ele^3;
                                     9/70*l_Ele, 13/420*l_Ele^2, 13/35*l_Ele, -11/210*l_Ele^2;
                                     -13/420*l_Ele^2, -1/140*l_Ele^3, -11/210*l_Ele^2, 1/105*l_Ele^3 ] + ... 
        rho*Flaechentraegheit(3) * [ 6/5/l_Ele, 1/10, -6/5/l_Ele, 1/10;
                                     1/10, 2/15*l_Ele, -1/10, -1/30*l_Ele;
                                     -6/5/l_Ele, -1/10, 6/5/l_Ele, -1/10;
                                     1/10, -1/30*l_Ele, -1/10, 2/15*l_Ele ];             

% yz-Ebene: translatorischer und rotatorischer Anteil
DDI_el2 = rho*Flaechentraegheit(1) * [ 13/35*l_Ele, -11/210*l_Ele^2, 9/70*l_Ele, 13/420*l_Ele^2;
                                     -11/210*l_Ele^2, 1/105*l_Ele^3, -13/420*l_Ele^2, -1/140*l_Ele^3;
                                     9/70*l_Ele, -13/420*l_Ele^2, 13/35*l_Ele, 11/210*l_Ele^2;
                                     13/420*l_Ele^2, -1/140*l_Ele^3, 11/210*l_Ele^2, 1/105*l_Ele^3 ] + ...
        rho*Flaechentraegheit(2) * [ 6/5/l_Ele, -1/10, -6/5/l_Ele, -1/10;
                                     -1/10, 2/15*l_Ele, 1/10, -1/30*l_Ele;
                                     -6/5/l_Ele, 1/10, 6/5/l_Ele, 1/10;
                                     -1/10, -1/30*l_Ele, 1/10, 2/15*l_Ele ];
% Kopplung von yz auf xz
DDI_el3 = rho*Flaechentraegheit(1) * [ 13/35*l_Ele, -11/210*l_Ele^2, 9/70*l_Ele, 13/420*l_Ele^2;
                                       11/210*l_Ele^2, -1/105*l_Ele^3, 13/420*l_Ele^2, 1/140*l_Ele^3;
                                       9/70*l_Ele, -13/420*l_Ele^2, 13/35*l_Ele, 11/210*l_Ele^2;
                                       -13/420*l_Ele^2, 1/140*l_Ele^3, -11/210*l_Ele^2, -1/105*l_Ele^3 ] + ... 
        rho*Flaechentraegheit(2)  *  [ 6/5/l_Ele, -1/10, -6/5/l_Ele, -1/10;
                                       1/10, -2/15*l_Ele, -1/10, 1/30*l_Ele;
                                       -6/5/l_Ele, 1/10, 6/5/l_Ele, 1/10;
                                       1/10, 1/30*l_Ele, -1/10, -2/15*l_Ele ];             

% Rueckwirkung von xz auf yz
DDI_el4 = -rho*Flaechentraegheit(1) * [ 13/35*l_Ele, 11/210*l_Ele^2, 9/70*l_Ele, -13/420*l_Ele^2;
                                        -11/210*l_Ele^2, -1/105*l_Ele^3, -13/420*l_Ele^2, 1/140*l_Ele^3;
                                        9/70*l_Ele, 13/420*l_Ele^2, 13/35*l_Ele, -11/210*l_Ele^2;
                                        13/420*l_Ele^2, 1/140*l_Ele^3, 11/210*l_Ele^2, -1/105*l_Ele^3 ] + ...
          -rho*Flaechentraegheit(3) * [ 6/5/l_Ele, 1/10, -6/5/l_Ele, 1/10;
                                        -1/10, -2/15*l_Ele, 1/10, 1/30*l_Ele;
                                        -6/5/l_Ele, -1/10, 6/5/l_Ele, -1/10;
                                        -1/10, 1/30*l_Ele, 1/10, -2/15*l_Ele];                                 
          
                                   
% Berechnung der steifigkeitsproportionalen Matrizen
                                 
function [DDI_el1, DDI_el2, DDI_el3, DDI_el4] = Berechne_DDI_K_El(l_Ele, E, Flaechentraegheit)

assert(Flaechentraegheit(2) == Flaechentraegheit(3))

% Biegung xz-Ebene (Bv*Bv)
DDI_el1 = E*Flaechentraegheit(3) * [ 12/l_Ele^3, 6/l_Ele^2, -12/l_Ele^3, 6/l_Ele^2;
                                     6/l_Ele^2, 4/l_Ele, -6/l_Ele^2, 2/l_Ele;
                                     -12/l_Ele^3, -6/l_Ele^2, 12/l_Ele^3, -6/l_Ele^2;
                                     6/l_Ele^2, 2/l_Ele, -6/l_Ele^2, 4/l_Ele];
% Biegung xy-Ebene (Bw*Bw)                                
DDI_el2 = E*Flaechentraegheit(2) * [ 12/l_Ele^3, -6/l_Ele^2, -12/l_Ele^3, -6/l_Ele^2;
                                     -6/l_Ele^2, 4/l_Ele, 6/l_Ele^2, 2/l_Ele;
                                     -12/l_Ele^3, 6/l_Ele^2, 12/l_Ele^3, 6/l_Ele^2;
                                     -6/l_Ele^2, 2/l_Ele, 6/l_Ele^2, 4/l_Ele]; %Biegung yz-Ebene
                                 
% Kreuzkoppelung yz auf xz (Bv*Bw)
DDI_el3 = E*Flaechentraegheit(2) * [ 12/l_Ele^3, -6/l_Ele^2, -12/l_Ele^3, -6/l_Ele^2;
                                      6/l_Ele^2, -4/l_Ele, -6/l_Ele^2, -2/l_Ele;
                                      -12/l_Ele^3, 6/l_Ele^2, 12/l_Ele^3, 6/l_Ele^2;
                                      6/l_Ele^2, -2/l_Ele, -6/l_Ele^2, -4/l_Ele];

% Kreuzkoppelung xz auf yz (Bw*Bv)
DDI_el4 = -E*Flaechentraegheit(2) * [ 12/l_Ele^3, 6/l_Ele^2, -12/l_Ele^3, 6/l_Ele^2;
                                      -6/l_Ele^2, -4/l_Ele, 6/l_Ele^2, -2/l_Ele;
                                      -12/l_Ele^3, -6/l_Ele^2, 12/l_Ele^3, -6/l_Ele^2;
                                      -6/l_Ele^2, -2/l_Ele, 6/l_Ele^2, -4/l_Ele];
                     
