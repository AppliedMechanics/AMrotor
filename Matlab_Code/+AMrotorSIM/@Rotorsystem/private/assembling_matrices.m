function [M,G,D,K] = assembling_matrices (pos, matrices, rotor)

rotorpar = rotor.cnfg;
nodes = rotor.nodes;
moment_of_inertia = rotor.moment_of_inertia;

%pos die Positionen 

m = matrices.m;
g = matrices.g;
d = matrices.d;
k = matrices.k;


n_nodes = length(nodes);
M=zeros(n_nodes*4, n_nodes*4);
D=zeros(n_nodes*4, n_nodes*4);
G=zeros(n_nodes*4, n_nodes*4);
K=zeros(n_nodes*4, n_nodes*4);

sd = rotorpar.shear_def;

    if (pos < 0 || pos > nodes(end))
        error('position out of system');
    else
        if pos == nodes(end)
            % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
            % zum letzten Element
            n0 = n_nodes-1;
            kappa = 1; %Kappa-Wert
            l_Ele = nodes(end)-nodes(end-1);
            PhiS = sd*moment_of_inertia(end-1,5)/l_Ele^2;
        else
            % Suche den linken Nachbarknoten
            % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
            n0=1;
            b=1;
            while nodes(n0+1) < pos
                n0 = n0+1;
            end
            l_Ele=nodes(n0+1)-nodes(n0);
            
            kappa = (pos-nodes(n0)) / l_Ele;
            
            while rotorpar.rotor_dimensions(b,1) <= pos
                  b=b+1;
            end
            PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;
        end
    end

% Formfunktionen
 
    bw=(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3, -l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)), 3*kappa^2-2*kappa^3+kappa*PhiS, -l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    % Positionen in Gesamtmatrix
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = n_nodes*2+n0*2-1;
    z4 = n_nodes*2+n0*2+2;
    
    %Masse   
    M(z1:z2,z1:z2) = M(z1:z2,z1:z2) + m(1,1)*(bv.'*bv); %für X - Richtung
    M(z3:z4,z3:z4) = M(z3:z4,z3:z4) + m(3,3)*(bw.'*bw); %für Y - Richtung
    
    %Daempfung
    D(z1:z2,z1:z2) = D(z1:z2,z1:z2) + d(1,1)*(bv.'*bv); %für X - Richtung
    D(z1:z2,z3:z4) = D(z1:z2,z3:z4) + d(1,3)*(bw.'*bw); %für Y - Richtung Koppelterm
    
    D(z3:z4,z3:z4) = D(z3:z4,z3:z4) + d(3,3)*(bw.'*bw); %für Y - Richtung
    D(z3:z4,z1:z2) = D(z3:z4,z1:z2) + d(3,1)*(bv.'*bv); %für X - Richtung Koppelterm
    

    %Gyroskopie
    G(z1:z2,z1:z2) = G(z1:z2,z1:z2) + g(1,1)*(bv.'*bv); %für X - Richtung
    G(z1:z2,z3:z4) = G(z1:z2,z3:z4) + g(1,3)*(bw.'*bw); %für Y - Richtung Koppelterm
    
    G(z3:z4,z3:z4) = G(z3:z4,z3:z4) + g(3,3)*(bw.'*bw); %für Y - Richtung
    G(z3:z4,z1:z2) = G(z3:z4,z1:z2) + g(3,1)*(bv.'*bv); %für X - Richtung Koppelterm

    
    %Steifigkeit
    K(z1:z2,z1:z2) = K(z1:z2,z1:z2) + k(1,1)*(bv.'*bv); %für X - Richtung
    K(z1:z2,z3:z4) = K(z1:z2,z3:z4) + k(1,3)*(bw.'*bw); %für Y - Richtung Koppelterm
    
    K(z3:z4,z3:z4) = K(z3:z4,z3:z4) + k(3,3)*(bw.'*bw); %für Y - Richtung
    K(z3:z4,z1:z2) = K(z3:z4,z1:z2) + k(3,1)*(bv.'*bv); %für X - Richtung Koppelterm

end
    



