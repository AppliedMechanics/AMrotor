function [dZ, I_1, I_2, F_1, F_2] = sys_rotor_FEM_JM_v04(t,Z,sys,par,m,common,mag,h)


if t > 0.0001
    k=1;
end

% Initialisierung und Extrahieren der Zustandsgroessen
dZ = zeros(length(Z),1);

phi=Z(1);
omega=Z(2);
domega = 0;

X  = Z(3:4*par.nKnoten+2);
Xd = Z(2+4*par.nKnoten+1:2*4*par.nKnoten+2);

%Kraefte

h_K= -sys.K*X;
h_D= -sys.D*Xd;

% figure;
% plot(h_K(1:2:2*par.nKnoten));
% hold on;
% plot(h_K(2*par.nKnoten+1:2:4*par.nKnoten));
% close;

%% Einsetzen eines PID-Reglers als externe Kraft
% Johannes Maierhofer
% 15.06.2016
%

%% Ergebnis an Lagerstellen transformieren

%Position der Sensoren auswählen und passenden Knoten dazu finden.
Position_1=0.1; %m
[P_1] = SucheKnotenZuPositionCW(par,Position_1);%x beta y alpha
Position_2=0.6; %m
[P_2] = SucheKnotenZuPositionCW(par,Position_2);%x beta y alpha

ds_1 = [Xd(P_1(1),:)',Xd(P_1(3),:)'];
ds_2 = [Xd(P_2(1),:)',Xd(P_2(3),:)'];

s_1 = [X(P_1(1),:)',X(P_1(3),:)'];
s_2 = [X(P_2(1),:)',X(P_2(3),:)'];

%%
%Fehlerdifferenz er, er1, er2
w_1 = [0,0]; %Sollgröße der Verschiebung = null
w_2 = [0,0];
dw_1 = [0,0];
dw_2 = [0,0];


err_1 = w_1-s_1; %Fehler = Sollgröße - Istgröße
err_2 = w_2-s_2;

i_err_1 = [dZ(2*4*par.nKnoten+2+1),dZ(2*4*par.nKnoten+2+1+1)];
i_err_2 = [dZ(2*4*par.nKnoten+2+1+2),dZ(2*4*par.nKnoten+2+1+3)];

d_err_1 = dw_1 - ds_1;
d_err_2 = dw_2 - ds_2;

%Regler
I_1 = [mag.Kp*err_1(1) + mag.Ki*i_err_1(1) + mag.Kd*d_err_1(1), mag.Kp*err_1(2) + mag.Ki*i_err_1(2) + mag.Kd*d_err_1(2)];
I_2 = [mag.Kp*err_2(1) + mag.Ki*i_err_2(1) + mag.Kd*d_err_2(1), mag.Kp*err_2(2) + mag.Ki*i_err_2(2) + mag.Kd*d_err_2(2)];

F_1=[mag.k_i*I_1(1) + mag.k_s*s_1(1),mag.k_i*I_1(2) + mag.k_s*s_1(2)];
F_2=[mag.k_i*I_2(1) + mag.k_s*s_2(1),mag.k_i*I_2(2) + mag.k_s*s_2(2)];

%%

Kraft1 = [F_1(1),F_1(2),0.1]; % [Fx, Fy, Position]
 [h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft1);
Kraft2 = [F_2(1),F_2(2),0.6]; % [Fx, Fy, Position]
 [h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft2);


h_ges = h_K + h_D + h.h ...
                        + (h.h_ZPsin.*(omega^2) + h.h_DBsin.*domega + h.h_sin).*sin(phi) ...
                        + (h.h_ZPcos.*(omega^2) + h.h_DBcos.*domega + h.h_cos).*cos(phi);


%% ODE-Form

dZ(1:4*par.nKnoten+2,1) = [omega;domega;Xd];
dZ(4*par.nKnoten+2+1:2*4*par.nKnoten+2,1) = sys.M\h_ges;   %Beschleunigung berechnen

%Integration des Fehlers für PID-Regler:
dZ(2*4*par.nKnoten+2+1,1) = err_1(1);
dZ(2*4*par.nKnoten+2+1+1,1) = err_1(2);
dZ(2*4*par.nKnoten+2+1+2,1) = err_2(1);
dZ(2*4*par.nKnoten+2+1+3,1) = err_2(2);

end