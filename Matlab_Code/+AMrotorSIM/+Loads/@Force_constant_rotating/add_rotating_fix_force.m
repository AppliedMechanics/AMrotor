function [h] = add_rotating_fix_force(h, Parameter,  rotorpar,  nodes,  moment_of_inertia)

% Parameter in Form Position, Unwuchtkraft, psi [in rad]

n_nodes = length(nodes);
Dim = size(Parameter);
sd = rotorpar.shear_def;
for n = 1:Dim(1)
    if (Parameter(n,1) < 0 || Parameter(n,1) > nodes(end))
        disp('Unwuchtmasse: ')
        disp(n)
        error('Angriffspunkt au√üerhalb des Rotors');
    else
        if Parameter(n,1) == nodes(end)
            % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
            % zum letzten Element
            n0 = n_nodes-1;
            kappa = 1; %Kappa-Wert
            l_Ele = nodes(end)-nodes(end-1);
        else
            % Suche den linken Nachbarknoten
            % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
            n0=1;
            b=1;
            while nodes(n0+1) <= Parameter(n,1)
                n0 = n0+1;
            end
            l_Ele=nodes(n0+1)-nodesn0);
            kappa = (Parameter(n,1)-nodes(n0)) / l_Ele;
            
            while rotorpar.rotor_dimensions(b,1) < Parameter(n,1)
                b=b+1;
                
            end
            PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;
        end
    end
  
    

%Faktor PhiS ber¸cksichtigt Schubspannung, 
%da Kreisquerschnitt f¸r beide Ebenen gleich!!    
    
% Formfunktionen_mit_Schub
 
    bw=(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3, -l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)), 3*kappa^2-2*kappa^3+kappa*PhiS, -l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    
    
    % Formfunktionen ohne Schub
    %bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
    %bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    % Positionen in Gesamtvektor
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = n_nodes*2+n0*2-1;
    z4 = n_nodes*2+n0*2+2;
    
    h.h_rotcos(z1:z2) = h.h_rotcos(z1:z2) + bv.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_rotcos(z3:z4) = h.h_rotcos(z3:z4) + bw.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_rotsin(z1:z2) = h.h_rotsin(z1:z2) - bv.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_rotsin(z3:z4) = h.h_rotsin(z3:z4) + bw.'*Parameter(n,2)*cos(Parameter(n,3));
    
    h.h_rotcos(z1:z2) = h.h_rotcos(z1:z2) + bv.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_rotcos(z3:z4) = h.h_rotcos(z3:z4) - bw.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_rotsin(z1:z2) = h.h_rotsin(z1:z2) + bv.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_rotsin(z3:z4) = h.h_rotsin(z3:z4) + bw.'*Parameter(n,2)*sin(Parameter(n,3));
end