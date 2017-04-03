function [KF] = simple_bearing_stiffnes(rotorpar,nodes,cnfg,moment_of_inertia)

bearing_par = [cnfg.bearing_stiff,cnfg.bearing_stiff,cnfg.bearing_pos1];

n_nodes = length(nodes);

KF=zeros(n_nodes*4, n_nodes*4);

sd = rotorpar.shear_def;

    if (bearing_par(n,3) < 0 || bearing_par(n,3) > nodes(end))
        disp('Diskrete Feder: ')
        disp(n)
        error('Angriffspunkt ausserhalb des Rotors');
    else
        if bearing_par(n,3) == nodes(end)
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
            while nodes(n0+1) <= bearing_par(n,3)
                n0 = n0+1;
            end
            l_Ele=nodes(n0+1)-nodes(n0);
            
            kappa = (bearing_par(n,3)-nodes(n0)) / l_Ele;
            
            while rotorpar.rotor_dimensions(b,1) <= bearing_par(n,3)
                  b=b+1;

            end
            PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;
        end
    end


%PhiS=sd*12*rotorpar.E_module*moment_of_inertia(2)/(shear_modulus*moment_of_inertia(1)*rotorpar.shear_factor*l_Ele^2);
%Faktor PhiS berücksichtigt Schubspannung, 
%da Kreisquerschnitt für beide Ebenen gleich!!    
    
% Formfunktionen
 
    bw=(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3, -l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)), 3*kappa^2-2*kappa^3+kappa*PhiS, -l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    % Positionen in Gesamtmatrix
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = n_nodes*2+n0*2-1;
    z4 = n_nodes*2+n0*2+2;
    
    KF(z1:z2,z1:z2) = KF(z1:z2,z1:z2) + bearing_par(n,1)*(bv.'*bv);
    
    KF(z3:z4,z3:z4) = KF(z3:z4,z3:z4) + bearing_par(n,2)*(bw.'*bw);
   
    
end

