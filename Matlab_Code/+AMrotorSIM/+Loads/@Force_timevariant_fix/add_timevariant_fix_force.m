function [h] = add_timevariant_fix_force(h,Parameter,rotorpar, nodes, moment_of_inertia)



sd = rotorpar.shear_def;

Fx=Parameter(1);
Fy=Parameter(2);
F1_Position=Parameter(3);


b=1;
n=2;
        while F1_Position > nodes(n)
          n = n+1;
        end

%         h.h(n*2-1)=Fx;
%         h.h(n*2*2-1)=Fy;
        
% Kraft greift an den Knoten n-1 und n an
nPos1 = n*2; %revelante Koordinaten: nPos1-3 bis nPos1 in v-Richtung
nPos2 = 2*length(nodes) + n*2; % relevante Koordinaten: nPos2-3 bis nPos2 in w-Richtung

l_Ele = nodes(n) - nodes(n-1);
xi = (F1_Position - nodes(n-1)) / l_Ele; % xi von 0 bis 1
kappa=xi;
     while rotorpar.rotor_dimensions(b,1) < Parameter(3)
     b=b+1;
    
     end
     PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;

% h = [B_V * Fx; B_W * Fy]
h.h(nPos1-3) = h.h(nPos1-3) + Fx *  (1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3)*(1/(1+PhiS));%(1-3*xi^2+2*xi^3);
h.h(nPos1-2) = h.h(nPos1-2) + Fx * -(l_Ele*(-kappa^3+2*kappa^2-kappa))*(1/(1+PhiS));    %l_Ele*xi*(xi-1)^2;
h.h(nPos1-1) = h.h(nPos1-1) + Fx *  (3*kappa^2-2*kappa^3)*(1/(1+PhiS));                 %xi^2*(3-2*xi);
h.h(nPos1)   = h.h(nPos1)   + Fx *   l_Ele*(-kappa^3+kappa^2)*(1/(1+PhiS));             %l_Ele*xi^2*(xi-1);

h.h(nPos2-3) = h.h(nPos2-3) + Fy * (1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3)*(1/(1+PhiS)); %(1-3*xi^2+2*xi^3);
h.h(nPos2-2) = h.h(nPos2-2) + Fy * (l_Ele*(-kappa^3+2*kappa^2-kappa))*(1/(1+PhiS));     %(-l_Ele)*xi*(xi-1)^2;
h.h(nPos2-1) = h.h(nPos2-1) + Fy * (3*kappa^2-2*kappa^3)*(1/(1+PhiS));                  %xi^2*(3-2*xi);
h.h(nPos2)   = h.h(nPos2)   + Fy *  -l_Ele*(-kappa^3+kappa^2)*(1/(1+PhiS));             %(-l_Ele)*xi^2*(xi-1);

   

end