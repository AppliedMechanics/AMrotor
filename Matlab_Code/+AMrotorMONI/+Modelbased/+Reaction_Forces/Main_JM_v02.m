% Run Skriptset - Unwuchtidentifikation
% JM - 24.06.2014; 07.04.2017
% CW - 12.04.2017
% Demo für WiBe
% Unwuchtsmatrixaufbau: - [zUnwucht, BetragUnwucht, PhaseUnwucht] 

clear all;
clc;

%--------------------------------------------------------------------------
% Hier Angaben zu Messdaten machen!
%--------------------------------------------------------------------------

%Angabe zu den Messdaten, die Ausgewertet werden sollen.
%Pfad_rU = Pfad zur Messung ohne Unwucht
Pfad_rU = '../../Messungen_JM_28-05-2014/Hochlauf_ohne_Unwucht_2/';
%Pfad_rU = '../../Messungen_JM_18-06-2014/Hochlauf_ohne-Unwucht_4/';
Drehzahlen_rU =[100:100:2000];

%Pfad_zU = Pfad zur Messung mit gesetzter Unwucht
Pfad_zU = '../../Messungen_JM_28-05-2014/Hochlauf_Unwucht_6_links00/' ;
%Pfad_zU = '../../Messungen_JM_18-06-2014/Hochlauf_Unwucht7.5gr_re_0/';
Drehzahlen_zU =[100:100:1000];
% Werte der gesetzten Unwucht
PositionZ = 'l'; % Werte "l" und "r" erlaubt
U_ID    = 6;   % ID der Unwucht. Unwucht wird weiter unten dann berechnet
Phi_Real  = +0.5*pi;   % rad ACHTUNG: Scheiben am Prüfstand sind um pi/2 verdreht. Also zur Beschriftung immer noch -1,57 dazuzählen!

%--------------------------------------------------------------------------
%Ab hier keine Angaben/Änderungen nötig!
%--------------------------------------------------------------------------
%Ermittlung der realen Position
if PositionZ == 'r'
    z_Real = 0.220; % - Position der Massenanbringung in meter
else if PositionZ == 'l'
    z_Real = 0.095;
    end
end

% Ermittlung der real aufgebrachten Unwucht
Radius = 0.050; % Radius des Lochkreises in Meter
Schraube = 0.012; % Gewicht der Befestigungsschraube kg

switch U_ID
    case 1
        U_Real = Radius*(Schraube + 0.008);
    case 2
        U_Real = Radius*(Schraube + 0.018);
    case 3
        U_Real = Radius*(Schraube + 0.028);
    case 4
        U_Real = Radius*(Schraube + 0.038);
    case 5
        U_Real = Radius*(Schraube + 0.048);
    case 6
        U_Real = Radius*(Schraube + 0.058);
    case 7
        U_Real = Radius*(Schraube + 0.068);
    case 8
        U_Real = Radius*(Schraube + 0.078);
    otherwise
        pause 
end

Realunwuchtsmatrix = [z_Real, U_Real, Phi_Real];

save RealUnwuchtsmatrix.mat Realunwuchtsmatrix;

%--------------------------------------------------------------------------

[F_GL_rest, F_WL_rest]=Rest_UnwuchtSchaetzer_JM_v12(Pfad_rU, Drehzahlen_rU);
Zusatz_UnwuchtSchaetzer_JM_v12(Pfad_zU, Drehzahlen_zU, F_GL_rest, F_WL_rest);

%--------------------------------------------------------------------------
clear all;
load RestUnwuchtsmatrix.mat
load ZusatzUnwuchtsmatrix.mat
load RealUnwuchtsmatrix.mat
