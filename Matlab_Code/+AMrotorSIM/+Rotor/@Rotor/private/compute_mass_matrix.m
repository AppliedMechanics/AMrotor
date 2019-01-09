function M = compute_mass_matrix(rotorpar, moment_of_inertia,nodes)

Dim = size(rotorpar.rotor_dimensions);
n_nodes = length(nodes);

  M = zeros(4*n_nodes, 4*n_nodes);
% M = zeros(4*n_nodes, 4*n_nodes);

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
    
    for n1 = nStart:nEnd-1 % Assemblieren der Massenmatrix
        [M_el1, M_el2] = Berechne_M_El(nodes(n1+1)-nodes(n1),rotorpar, moment_of_inertia(n,:)); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        M(z1:z2,z1:z2) = M(z1:z2,z1:z2) + M_el1(:,:);
        z1 = n_nodes*2+n1*2-1;
        z2 = n_nodes*2+n1*2+2;
        M(z1:z2,z1:z2) = M(z1:z2,z1:z2) + M_el2(:,:);
    end
end

function [M_el1, M_el2] = Berechne_M_El(l_Ele, rotorpar, moment_of_inertia)

assert(moment_of_inertia(2) == moment_of_inertia(3));
shear_modulus = rotorpar.E_module/(2*(1+rotorpar.poisson));
sd = rotorpar.shear_def;
PhiS=sd*12*rotorpar.E_module*moment_of_inertia(2)/(shear_modulus*moment_of_inertia(1)*rotorpar.shear_factor*l_Ele^2);

%Faktor PhiS berücksichtigt Schubspannung, da Kreisquerschnitt 
%für beide Ebenen gleich!!

mt1=zeros(4,4);
mr1=zeros(4,4);

mt1(1,1) = 13/35+7/10*PhiS+1/3*PhiS^2;
mt1(1,2) =(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt1(1,3) = 9/70+3/10*PhiS+1/6*PhiS^2;
mt1(1,4) =-(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;

mt1(2,1) =(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt1(2,2) =(1/105+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;
mt1(2,3) =(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt1(2,4) =-(1/140+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;

mt1(3,1) = 9/70+3/10*PhiS+1/6*PhiS^2;
mt1(3,2) =(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt1(3,3) = 13/35+7/10*PhiS+1/3*PhiS^2;
mt1(3,4) =-(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;

mt1(4,1) =-(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt1(4,2) =-(1/140+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;
mt1(4,3) =-(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt1(4,4) = (1/105+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;

mr1(1,1) = 6/5;
mr1(1,2) =(1/10-0.5*PhiS)*l_Ele;
mr1(1,3) = -6/5;
mr1(1,4) =(1/10-0.5*PhiS)*l_Ele;

mr1(2,1) = (1/10-0.5*PhiS)*l_Ele;
mr1(2,2) =(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;
mr1(2,3) =-(1/10-0.5*PhiS)*l_Ele;
mr1(2,4) =-(1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;

mr1(3,1) =-6/5;
mr1(3,2) =-(1/10-0.5*PhiS)*l_Ele;
mr1(3,3) = 6/5;
mr1(3,4) =-(1/10-0.5*PhiS)*l_Ele;

mr1(4,1) =(1/10-0.5*PhiS)*l_Ele;
mr1(4,2) =-(1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;
mr1(4,3) =-(1/10-0.5*PhiS)*l_Ele;
mr1(4,4) =(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;

mt2=zeros(4,4);
mr2=zeros(4,4);

mt2(1,1) = 13/35+7/10*PhiS+1/3*PhiS^2;
mt2(1,2) =-(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt2(1,3) =  9/70+3/10*PhiS+1/6*PhiS^2;
mt2(1,4) = (13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;

mt2(2,1) =-(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt2(2,2) = (1/105+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;
mt2(2,3) =-(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt2(2,4) =-(1/140+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;

mt2(3,1) = 9/70+3/10*PhiS+1/6*PhiS^2;
mt2(3,2) =-(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt2(3,3) = 13/35+7/10*PhiS+1/3*PhiS^2;
mt2(3,4) =(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;

mt2(4,1) =(13/420+3/40*PhiS+1/24*PhiS^2)*l_Ele;
mt2(4,2) =-(1/140+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;
mt2(4,3) =(11/210+11/120*PhiS+1/24*PhiS^2)*l_Ele;
mt2(4,4) =(1/105+1/60*PhiS+1/120*PhiS^2)*l_Ele^2;

mr2(1,1) = 6/5;
mr2(1,2) =-(1/10-0.5*PhiS)*l_Ele;
mr2(1,3) =- 6/5;
mr2(1,4) =-(1/10-0.5*PhiS)*l_Ele;

mr2(2,1) = -(1/10-0.5*PhiS)*l_Ele;
mr2(2,2) =(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;
mr2(2,3) = (1/10-0.5*PhiS)*l_Ele;
mr2(2,4) =-(1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;

mr2(3,1) = -6/5;
mr2(3,2) =(1/10-0.5*PhiS)*l_Ele;
mr2(3,3) = 6/5;
mr2(3,4) =(1/10-0.5*PhiS)*l_Ele;

mr2(4,1) =-(1/10-0.5*PhiS)*l_Ele;
mr2(4,2) =-(1/30+1/6*PhiS-1/6*PhiS^2)*l_Ele^2;
mr2(4,3) =(1/10-0.5*PhiS)*l_Ele;
mr2(4,4) =(2/15+1/6*PhiS+1/3*PhiS^2)*l_Ele^2;

% xz-Ebene: translatorischer und rotatorischer Anteil
M_el1 = (l_Ele*rotorpar.density*moment_of_inertia(1)/((1+PhiS)^2))*mt1+(rotorpar.density*moment_of_inertia(3)/(l_Ele*(1+PhiS)^2))*mr1;

% yz-Ebene: translatorischer und rotatorischer Anteil
M_el2 = (l_Ele*rotorpar.density*moment_of_inertia(1)/((1+PhiS)^2))*mt2+(rotorpar.density*moment_of_inertia(2)/(l_Ele*(1+PhiS)^2))*mr2;



                                 
                     

