
function [geometry_par, volume_rotor, JzzNorm] = compute_moment_of_inertia(rotorpar)

% Welle sei ideal kreisrund
shear_modulus = rotorpar.E_module/(2*(1+rotorpar.poisson)); %G
Dim = size(rotorpar.rotor_dimensions);
geometry_par = zeros(Dim(1), 5);
volume_rotor = 0;
JzzNorm = 0; % int r^2 dV, entspricht J auf Einheitsdichte normiert 






for n = 1:Dim(1)-1
    geometry_par(n,1) = pi*(0.25*rotorpar.rotor_dimensions(n,2)^2-0.25*rotorpar.rotor_dimensions(n,3)^2); % Flaeche
    geometry_par(n,2) = pi*((0.5*rotorpar.rotor_dimensions(n,2))^4/4-(0.5*rotorpar.rotor_dimensions(n,3))^4/4); % I_xi
    geometry_par(n,3) = geometry_par(n,2); % I_eta, bei Kreisquerschnitt gilt I_eta=I_xi
    geometry_par(n,4) = geometry_par(n,2) + geometry_par(n,3); % I_p=I_xi+I_eta, gilt allgemein im Hauptachsensystem
    
    k = rotorpar.rotor_dimensions(n,3);
    rotorpar.shear_factor = 0.5;
    if k == 0
        rotorpar.shear_factor  = 0.9;
    else 
        rotorpar.shear_factor  = 0.5;
    end
    m=rotorpar.shear_factor;
    
    geometry_par(n,5) = (12*rotorpar.E_module*geometry_par(n,2))/(shear_modulus*geometry_par(n,1)*rotorpar.shear_factor); %muss noch durch Elementlänge^2 geteilt werden
   
    volume_rotor = volume_rotor + geometry_par(n,1)*(rotorpar.rotor_dimensions(n+1,1)-rotorpar.rotor_dimensions(n,1));
    JzzNorm = JzzNorm + geometry_par(n,4)*(rotorpar.rotor_dimensions(n+1,1)-rotorpar.rotor_dimensions(n,1));
end