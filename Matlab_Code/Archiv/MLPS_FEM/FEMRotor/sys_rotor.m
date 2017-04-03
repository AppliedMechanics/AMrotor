function Z = sys_rotor(t,z,sys,par,m)

% %Als Trigger zum Debuggen
%    if t>0
%        stop=1;
%    end
%     
% Initialisierung und Extrahieren der Zustandsgroessen
Z = zeros(length(z),1);

phi=z(1);
omega=z(2);
domega = 0;


x  = z(3:par.Moden+2);
xd = z(2+par.Moden+1:2*par.Moden+2);

% qd = T(q)*u !
% Kinematik
%Kraefte

mh_K= -m.K*x;
mh_D= -m.D*xd;

%%

% 
% %Selbstverstärkung durch Rotorbiegung
% h_mv= M*EV*x .*omega^2;
% h_mv(2:2:end)=0; %Rotatorische Anteile erzeugen keine Fliehkraft
% mh_mv=EV'*h_mv;

mh_ges = (mh_K +mh_D + m.h +(m.h_ZPsin.*(omega^2) + m.h_DBsin.*domega +m.h_sin).*sin(phi) ...
              +(m.h_ZPcos.*(omega^2) + m.h_DBcos.*domega +m.h_cos).*cos(phi)) ...
              + m.h_rotsin.*sin(phi*par.harmonische1) + m.h_rotcos.*cos(phi*par.harmonische1); %+Dichtung+Lager


%% ODE-Form
Z(1:par.Moden+2,1) = [omega;domega;xd];
Z(par.Moden+2+1:end,1) = m.M\mh_ges;   %Beschleunigung berechnen
% ODE-Form reduziert


end