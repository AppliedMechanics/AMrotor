function [h] = assembling_loads (load, rotor)

pos = load.cnfg.position;
rotorpar = rotor.cnfg;
nodes = rotor.nodes;
moment_of_inertia = rotor.moment_of_inertia;

%pos die Positionen 

h1_ZPcos = load.h.h_ZPcos;
h1_ZPsin = load.h.h_ZPsin;
h1_DBcos = load.h.h_DBcos;
h1_DBsin = load.h.h_DBsin;


n_nodes = length(nodes);
M=zeros(n_nodes*4, n_nodes*4);
D=zeros(n_nodes*4, n_nodes*4);
G=zeros(n_nodes*4, n_nodes*4);
K=zeros(n_nodes*4, n_nodes*4);

h.h = zeros(4*n_nodes,1);   

%centripetal-force unbalance, rotating
h.h_ZPsin = h.h;                                      
h.h_ZPcos = h.h;   

%unbalance mass inertia force 
h.h_DBsin = h.h;                                 
h.h_DBcos = h.h;


%Constant_fix_force   e.g wight force
h.h_sin = h.h;                     
h.h_cos = h.h;


%rotating_fix_force%   e.g  bearing exitation 
h.h_rotsin = h.h;                   
h.h_rotcos = h.h;

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

% Formfunktionen_mit_Schub
 
    bw=(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3, -l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)), 3*kappa^2-2*kappa^3+kappa*PhiS, -l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    
    
    % Formfunktionen_ohne_schub
    
    %bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
    %bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    % Positionen in Gesamtvektor
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = n_nodes*2+n0*2-1;
    z4 = n_nodes*2+n0*2+2;
    
    h.h_ZPcos(z1:z2) = h.h_ZPcos(z1:z2) + bv.'*h1_ZPcos(1);
    h.h_ZPcos(z3:z4) = h.h_ZPcos(z3:z4) + bw.'*h1_ZPcos(3);
    h.h_ZPsin(z1:z2) = h.h_ZPsin(z1:z2) - bv.'*h1_ZPsin(1);
    h.h_ZPsin(z3:z4) = h.h_ZPsin(z3:z4) + bw.'*h1_ZPsin(3);
    
    h.h_DBcos(z1:z2) = h.h_DBcos(z1:z2) + bv.'*h1_DBcos(1);
    h.h_DBcos(z3:z4) = h.h_DBcos(z3:z4) - bw.'*h1_DBcos(3);
    h.h_DBsin(z1:z2) = h.h_DBsin(z1:z2) + bv.'*h1_DBsin(1);
    h.h_DBsin(z3:z4) = h.h_DBsin(z3:z4) + bw.'*h1_DBsin(3);

end
    



