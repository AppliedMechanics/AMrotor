function G = compute_gyroscopic_matrix(rotorpar, moment_of_inertia,nodes)

Dim = size(rotorpar.rotor_dimensions);
n_nodes = length(nodes);

G = zeros(4*n_nodes, 4*n_nodes);

for n = 1:Dim(1)-1
    
    % Suche nach Knoten, die zu jeweiligen Abschnitt gehoeren
    n1=1;
    while rotorpar.rotor_dimensions(n,1) > nodes(n1)
        n1 = n1+1;
    end
    assert(rotorpar.rotor_dimensions(n,1)==nodes(n1),'Kein Knoten an Unstetigkeit');
    nStart = n1;
    
    while rotorpar.rotor_dimensions(n+1,1) > nodes(n1)
        n1 = n1+1;
    end
    assert(rotorpar.rotor_dimensions(n+1,1)==nodes(n1),'Kein Knoten an Unstetigkeit');
    nEnd = n1;
    
    for n1 = nStart:nEnd-1 % Assemblieren der Steifigkeitsmatrix
        [G_el1, G_el2] = compute_G_El(nodes(n1+1)-nodes(n1),moment_of_inertia(n,:),rotorpar); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        z3 = n_nodes*2+n1*2-1;
        z4 = n_nodes*2+n1*2+2;
        
        G(z1:z2,z3:z4) = G(z1:z2,z3:z4) + G_el1(:,:);
        G(z3:z4,z1:z2) = G(z3:z4,z1:z2) + G_el2(:,:);
    end
end


function [G_el1, G_el2] = compute_G_El(l_Ele, moment_of_inertia,rotorpar)
shear_modulus = rotorpar.E_module/(2*(1+rotorpar.poisson));
sd = rotorpar.shear_def;
PhiS=sd*12*rotorpar.E_module*moment_of_inertia(2)/(shear_modulus*moment_of_inertia(1)*rotorpar.shear_factor*l_Ele^2);

%PhiS = sd*moment_of_inertia(5)/l_Ele^2;
%Faktor PhiS berücksichtigt Schubspannung, da Kreisquerschnitt für beide
%Ebenen gleich!!

gr1(1,1) = 6/5;
gr1(1,2) =-(1/10-0.5*PhiS)*l_Ele;
gr1(1,3) = -6/5;
gr1(1,4) = -(1/10-0.5*PhiS)*l_Ele;

gr1(2,1) = (1/10-0.5*PhiS)*l_Ele;
gr1(2,2) = -(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;
gr1(2,3) = -(1/10-0.5*PhiS)*l_Ele;
gr1(2,4) = (1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;

gr1(3,1) = -6/5;
gr1(3,2) = (1/10-0.5*PhiS)*l_Ele;
gr1(3,3) = 6/5;
gr1(3,4) = (1/10-0.5*PhiS)*l_Ele;

gr1(4,1) = (1/10-0.5*PhiS)*l_Ele;
gr1(4,2) = (1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;
gr1(4,3) = -(1/10-0.5*PhiS)*l_Ele;
gr1(4,4) = -(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;


gr2(1,1) =  6/5;
gr2(1,2) = (1/10-0.5*PhiS)*l_Ele;
gr2(1,3) = -6/5;
gr2(1,4) = (1/10-0.5*PhiS)*l_Ele;

gr2(2,1) = -(1/10-0.5*PhiS)*l_Ele;
gr2(2,2) = -(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;
gr2(2,3) = (1/10-0.5*PhiS)*l_Ele;
gr2(2,4) = (1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;

gr2(3,1) = -6/5;
gr2(3,2) = -(1/10-0.5*PhiS)*l_Ele;
gr2(3,3) = 6/5;
gr2(3,4) = -(1/10-0.5*PhiS)*l_Ele;

gr2(4,1) = -(1/10-0.5*PhiS)*l_Ele;
gr2(4,2) = (1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;
gr2(4,3) = (1/10-0.5*PhiS)*l_Ele;
gr2(4,4) = -(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;


% Rueckwirkung von yz auf xz
G_el1 = (rotorpar.density*moment_of_inertia(4)/(l_Ele*(1+PhiS)^2)) *gr1;
           % [ g11, -g12, -g13, -g14;
            %  g21, -g22, -g23,  g24;
            % -g31,  g32,  g33,  g34;
            %  g41,  g42, -g43, -g44 ];             

% Rueckwirkung von xz auf yz
G_el2 = (-rotorpar.density*moment_of_inertia(4)/(l_Ele*(1+PhiS)^2)) *gr2;
         %   [ g11, g12,-g13, g14;
          %   -g21,-g22, g23, g24;
           %  -g31,-g32, g33,-g34;
            % -g41, g42, g43,-g44];
                     
