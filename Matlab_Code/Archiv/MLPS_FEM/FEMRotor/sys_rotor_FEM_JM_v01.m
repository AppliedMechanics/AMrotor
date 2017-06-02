function [dZ, I_1, I_2, F_1, F_2] = sys_rotor_FEM_JM_v01(t,Z,sys,par,m,common,mag,h)

% Initialisierung und Extrahieren der Zustandsgroessen
dZ = zeros(length(Z),1);

phi=Z(1);
omega=Z(2);
domega = 0;


x  = Z(3:par.Moden+2);
xd = Z(2+par.Moden+1:2*par.Moden+2);

% qd = T(q)*u !
% Kinematik
%Kraefte

mh_K= -m.K*x;
mh_D= -m.D*xd;

%% Einsetzen eines PID-Reglers als externe Kraft
% Johannes Maierhofer
% 15.06.2016
%

%% Ergebnis an Lagerstellen transformieren
% Rücktransformation der Modalen Ergebnisse in Konfigurationsraum

%mX= Z(3:2+par.Moden,:);
mX = x;
X = m.EV*mX;

%Position der Sensoren auswählen und passenden Knoten dazu finden.
Position_1=0; %m
[P_1] = SucheKnotenZuPositionCW(par,Position_1);%x beta y alpha
Position_2=0.7; %m
[P_2] = SucheKnotenZuPositionCW(par,Position_2);%x beta y alpha

s_1 = [X(P_1(1),:)',X(P_1(3),:)'];
s_2 = [X(P_2(1),:)',X(P_2(3),:)'];

%%
%Fehlerdifferenz er, er1, er2
w_1 = [0,0]; %Sollgröße der Verschiebung = null
w_2 = [0,0];

err_1 = w_1-s_1; %Fehler = Sollgröße - Istgröße
err_2 = w_2-s_2;

i_err_1 = [dZ(2*par.Moden+2+1),dZ(2*par.Moden+2+1+1)];
i_err_2 = [dZ(2*par.Moden+2+1+2),dZ(2*par.Moden+2+1+3)];

d_err_1 = [(dZ(2*par.Moden+2+1)-err_1)/common.T,(dZ(2*par.Moden+2+1+1)-err_1)/common.T];
d_err_2 = [(dZ(2*par.Moden+2+1+2)-err_2)/common.T,(dZ(2*par.Moden+2+1+3)-err_2)/common.T];

%Regler
I_1 = [mag.Kp*err_1(1) + mag.Ki*i_err_1(1) + mag.Kd*d_err_1(1) + mag.Iv, mag.Kp*err_1(2) + mag.Ki*i_err_1(2) + mag.Kd*d_err_1(2) + mag.Iv];
I_2 = [mag.Kp*err_2(1) + mag.Ki*i_err_2(1) + mag.Kd*d_err_2(1) + mag.Iv, mag.Kp*err_2(2) + mag.Ki*i_err_2(2) + mag.Kd*d_err_2(2) + mag.Iv];


F_1=[mag.k_i*I_1(1) + mag.k_s*s_1(1),mag.k_i*I_1(2) + mag.k_s*s_1(2)];
F_2=[mag.k_i*I_2(1) + mag.k_s*s_2(1),mag.k_i*I_2(2) + mag.k_s*s_2(2)];

%%

%
% %Selbstverstärkung durch Rotorbiegung
% h_mv= M*EV*x .*omega^2;
% h_mv(2:2:end)=0; %Rotatorische Anteile erzeugen keine Fliehkraft
% mh_mv=EV'*h_mv;

Kraft1 = [F_1(1),F_1(2),0]; % [Fx, Fy, Position]
[h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft1);
Kraft2 = [F_2(1),F_2(2),0.7]; % [Fx, Fy, Position]
[h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft2);

m.h = m.EV'*h.h;

mh_ges = (mh_K + mh_D + m.h +(m.h_ZPsin.*(omega^2) + m.h_DBsin.*domega +m.h_sin).*sin(phi) ...
    +(m.h_ZPcos.*(omega^2) + m.h_DBcos.*domega +m.h_cos).*cos(phi));

%% ODE-Form

dZ(1:par.Moden+2,1) = [omega;domega;xd];
dZ(par.Moden+2+1:2*par.Moden+2,1) = m.M\mh_ges;   %Beschleunigung berechnen
%Integration von Abweichung zum Sollwert für PID-Regler
dZ(2*par.Moden+2+1,1) = err_1(1);
dZ(2*par.Moden+2+1+1,1) = err_1(2);
dZ(2*par.Moden+2+1+2,1) = err_2(1);
dZ(2*par.Moden+2+1+3,1) = err_2(2);


end