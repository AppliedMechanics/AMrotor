function K_B = compute_stiffness_matrix(rotorpar, moment_of_inertia, nodes)

Dim = size(rotorpar.rotor_dimensions);
n_nodes = length(nodes);

K_B = zeros(4*n_nodes, 4*n_nodes);

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
        [K_B_el1, K_B_el2] = Berechne_K_B_El(nodes(n1+1)-nodes(n1),rotorpar, moment_of_inertia(n,:)); %Elementsteifigkeitsmatrix
        % Einordnen in Gesamtmatrix
        z1 = n1*2-1;
        z2 = n1*2+2;
        K_B(z1:z2,z1:z2) = K_B(z1:z2,z1:z2) + K_B_el1(:,:);
        z1 = n_nodes*2+n1*2-1;
        z2 = n_nodes*2+n1*2+2;
        K_B(z1:z2,z1:z2) = K_B(z1:z2,z1:z2) + K_B_el2(:,:);
    end
end


function [K_B_el1, K_B_el2] = Berechne_K_B_El(l_Ele,rotorpar,moment_of_inertia)

assert(moment_of_inertia(2) == moment_of_inertia(3))


sd = rotorpar.shear_def;
PhiS=sd*moment_of_inertia(5)/l_Ele^2;
%Faktor PhiS berücksichtigt Schubspannung, 
%da Kreisquerschnitt für beide Ebenen gleich!!

k11 = 12/l_Ele^3;
k12 = 6/l_Ele^2;
k13 = k11;
k14 = k12;

k21 = k12;
k22 =(4+PhiS)/l_Ele;
k23 = k12; 
k24 =(2-PhiS)/l_Ele;

k31 = k11;
k32 = k12;
k33 = k11;
k34 = k12;

k41 = k12;
k42 = k24;
k43 = k12;
k44 = k22;


%Biegung xz-Ebene
K_B_el1 = rotorpar.E_module*moment_of_inertia(3)/(1+PhiS)*[ k11, k12,-k13, k14;
                                                            k21, k22,-k23, k24;
                                                           -k31,-k32, k33,-k34;
                                                            k41, k42,-k43, k44];
                                              

%Biegung xy-Ebene
K_B_el2 = rotorpar.E_module*moment_of_inertia(2)/(1+PhiS) *[ k11,-k12,-k13,-k14;
                                                            -k21, k22, k23, k24;
                                                            -k31, k32, k33, k34;
                                                            -k41, k42, k43, k44]; 
                                               

                     
