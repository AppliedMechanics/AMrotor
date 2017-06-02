function Z = rotor_sys_function(t,z,K,M,D,G,h,omega_rot_const_force,method)

% Initialisierung und Extrahieren der Zustandsgroessen

% Zustandsvektor Z Aufbau [{q_punkt};{q_punkt_punkt};phi;omega]
% q enthaelt freihetsgrade der Knoten

Z = zeros(length(z),1);


dim    = size(M);
if method == 0
    
phi=z(end-1);                                               %phi    = z(end-2);
omega=z(end);                                               %omega  = z(end-1);
domega = 0;                                                 %domega = z(end); 
ddomega =0;

end

if method == 1
    
phi=z(end-2);                                               %phi    = z(end-2);
omega=z(end-1);                                               %omega  = z(end-1);
domega = z(end);                                                 %domega = z(end); 
ddomega =0;

end

% Z0(end-2) = 0; %phi
% Z0(end-1) = 0; %omega
% Z0(end) = 0;   %domega


x  = z(1:dim(1));              
xd = z(dim(1)+1:2*dim(1));

% qd = T(q)*u !
% Kinematik
%Kraefte

h_K= -K*x;
h_DG= -(D+omega*G)*xd;

h_ges = (h_K +h_DG + h.h +(h.h_ZPsin.*(omega^2) + h.h_DBsin.*domega +h.h_sin).*(-1)*sin(phi) ...
              +(h.h_ZPcos.*(omega^2) + h.h_DBcos.*domega +h.h_cos).*(-1)*cos(phi)) ...
              + h.h_rotsin.*sin(phi*omega_rot_const_force) + h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager


          
%% ODE_Form
Z(1:dim(1),1)     = xd;           

Z(dim(1)+1:2*dim(1)) = pinv(M)*h_ges;   

if method == 0
Z(end-1,1)       = omega;                                                                                                   
Z(end,1)         = domega;                             
end

if method == 1
Z(end-2) = omega;
Z(end-1) = domega; 
Z(end)   = ddomega;    
end


end