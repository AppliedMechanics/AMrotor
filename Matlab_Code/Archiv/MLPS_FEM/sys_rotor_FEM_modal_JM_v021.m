function [dZ, I_1, I_2, F_1, F_2] = sys_rotor_FEM_modal_JM_v021(t,Z,sys,par,m,common,mag,komp,h)

% Initialisierung und Extrahieren der Zustandsgroessen
dZ = zeros(length(Z),1);

phi=Z(1);
omega=Z(2);
domega = 0;

% if phi > 360
%    phi = 0;
%    Z(1) = 0;
% end

x  = Z(3:par.Moden+2);
xd = Z(2+par.Moden+1:2*par.Moden+2);

% qd = T(q)*u !
% Kinematik
%Kraefte

mh_K= -m.K*x;
mh_D= -m.D*xd;

%% Ergebnis an Lagerstellen transformieren
% Rücktransformation der Modalen Ergebnisse in Konfigurationsraum

mX = x;
mXd = xd;
X = m.EV*mX;
Xd = m.EV*mXd;

%Position der Sensoren auswählen und passenden Knoten dazu finden.
Position_1=0.1; %m
[P_1] = SucheKnotenZuPositionCW(par,Position_1);%x beta y alpha
Position_2=0.6; %m
[P_2] = SucheKnotenZuPositionCW(par,Position_2);%x beta y alpha

ds_1 = [Xd(P_1(1),:)',Xd(P_1(3),:)'];
ds_2 = [Xd(P_2(1),:)',Xd(P_2(3),:)'];

s_1 = [X(P_1(1),:)',X(P_1(3),:)'];
s_2 = [X(P_2(1),:)',X(P_2(3),:)'];

%% Einspeisen der Anregung #Stabilitätstest

time = 0:common.T:common.Tend;
e_1 = [interp1(time,par.Anregung_Weg_inertial_1(1,:),t),interp1(time,par.Anregung_Weg_inertial_1(2,:),t)];
e_2 = [interp1(time,par.Anregung_Weg_inertial_2(1,:),t),interp1(time,par.Anregung_Weg_inertial_2(2,:),t)];

s_1 = s_1+e_1;
s_2 = s_2+e_2;

%%
%Fehlerdifferenz er, er1, er2
w_1 = [0,0]; %Sollgröße der Verschiebung = null
w_2 = [0,0];
dw_1 = [0,0];
dw_2 = [0,0];


err_1 = w_1-s_1; %Fehler = Sollgröße - Istgröße
err_2 = w_2-s_2;

i_err_1 = [dZ(2*par.Moden+2+1),dZ(2*par.Moden+2+1+1)];
i_err_2 = [dZ(2*par.Moden+2+1+2),dZ(2*par.Moden+2+1+3)];


d_err_1 = dw_1 - ds_1;
d_err_2 = dw_2 - ds_2;

%Regler
I_1 = [mag.Kp*err_1(1) + mag.Ki*i_err_1(1) + mag.Kd*d_err_1(1) + cos(phi*komp.EO+komp.phase)*komp.amp, mag.Kp*err_1(2) + mag.Ki*i_err_1(2) + mag.Kd*d_err_1(2)+ sin(phi*komp.EO+komp.phase)*komp.amp];
I_2 = [mag.Kp*err_2(1) + mag.Ki*i_err_2(1) + mag.Kd*d_err_2(1) + cos(phi*komp.EO+komp.phase)*komp.amp, mag.Kp*err_2(2) + mag.Ki*i_err_2(2) + mag.Kd*d_err_2(2)+ sin(phi*komp.EO+komp.phase)*komp.amp];


F_1=[mag.k_i*I_1(1) + mag.k_s*s_1(1),mag.k_i*I_1(2) + mag.k_s*s_1(2)];
F_2=[mag.k_i*I_2(1) + mag.k_s*s_2(1),mag.k_i*I_2(2) + mag.k_s*s_2(2)];

%%

%
% %Selbstverstärkung durch Rotorbiegung
% h_mv= M*EV*x .*omega^2;
% h_mv(2:2:end)=0; %Rotatorische Anteile erzeugen keine Fliehkraft
% mh_mv=EV'*h_mv;

Kraft1 = [F_1(1),F_1(2),0.1]; % [Fx, Fy, Position]
[h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft1);
Kraft2 = [F_2(1),F_2(2),0.6]; % [Fx, Fy, Position]
[h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft2);

m.h = m.EV'*h.h;

mh_ges = (mh_K + mh_D + m.h +(m.h_ZPsin.*(omega^2) + m.h_DBsin.*domega +m.h_sin).*sin(phi) ...
    +(m.h_ZPcos.*(omega^2) + m.h_DBcos.*domega +m.h_cos).*cos(phi));

%% ODE-Form

dZ(1:par.Moden+2,1) = [omega;domega;xd];          % Drehbeschleunigung/Winkelgeschwindigkeit/Winkel aurechnen
dZ(par.Moden+2+1:2*par.Moden+2,1) = m.M\mh_ges;   %Beschleunigung berechnen
%Integration von Abweichung zum Sollwert für PID-Regler
dZ(2*par.Moden+2+1,1) = err_1(1);
dZ(2*par.Moden+2+1+1,1) = err_1(2);
dZ(2*par.Moden+2+1+2,1) = err_2(1);
dZ(2*par.Moden+2+1+3,1) = err_2(2);


end