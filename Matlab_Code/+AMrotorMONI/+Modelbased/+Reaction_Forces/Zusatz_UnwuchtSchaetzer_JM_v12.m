function Zusatz_UnwuchtSchaetzer_JM_v12(Pfad_zU, Drehzahlen_zU, F_GL_rest, F_WL_rest)
%Zusatz - Unwucht Schätzer JM 24.06.2014
%Laval Rotor als Grundlage
%
%Betrachtung nur von Gleichlauf!!
%
% - auf Hochlauf mit Unwucht anwenden. Im Workspace sollten die Werte
% F_GL_rest und F_WL_rest aus der Rest_UnwuchtSchaetzer_JM_v10 vorliegen.
% Unwuchtsmatrixaufbau: - [zUnwucht, BetragUnwucht, PhaseUnwucht] 

clc
close all

Wellenlaenge = 0.59; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz = 63.5*2*pi;   %Eigenfrequenz des Rotors in rad/sec.


for i1=1:length(Drehzahlen_zU)
    Name=[Pfad_zU , 'Messdaten/Hochlauf2-',num2str(Drehzahlen_zU(i1)),'.mat'];
    load(Name)
    [~,OmegaExakt(i1),Gleichlauf_FGL(i1,:),Gegenlauf_FGL(i1,:), Gleichlauf_FWL(i1,:), Gegenlauf_FWL(i1,:)] = AnalysiereEO_3SensorenJM_v04(data);      
end

eta = OmegaExakt./Eigenfrequenz;

c = 1./(1-eta.^2);
d = eta.^2./(1-eta.^2);

A = [c', d'];

 F_GL_trenn = A\Gleichlauf_FGL(:,1);      %Überbestimmtes Gleichungssystem lösen.
 F_WL_trenn = A\Gleichlauf_FWL(:,1);
 
 %Erste Zeile von F_GL_trenn entspricht Kupplungsversatz
 %Zweite Zeile entspricht den quadratisch skalierenden Anteilen
 
 %Abziehen der Kräfte aus der Rest_UnwuchtSchaetzer_JM_v10.m
 F_GL_zusatz = F_GL_trenn(2) - F_GL_rest;
 F_WL_zusatz = F_WL_trenn(2) - F_WL_rest;

 %-------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:
    %Unwucht = 0.5*(abs(F_GL_zusatz)+abs(F_WL_zusatz))/Eigenfrequenz^2;
    Unwucht_komplex = abs(F_GL_zusatz+F_WL_zusatz)/Eigenfrequenz^2;
    Unwucht = abs(Unwucht_komplex);
    
    %Position der Unwucht über beide Momentenggw.:
    pos_rel = abs(F_WL_zusatz)/(abs(F_GL_zusatz)+abs(F_WL_zusatz));
    z1 = pos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    %phi_1 = atan2(imag(F_GL_zusatz),real(F_GL_zusatz));
    %phi_2 = atan2(imag(F_WL_zusatz),real(F_WL_zusatz));
    
    %phi = 0.5*(phi_1+phi_2); %gemittelte Phase
    phi = phase(Unwucht);
    
   % createfigure_Phasenlage_JM_v06([0,F_GL_trenn(1)], [0,F_WL_trenn(1)], 0 ,'Kupplungsversatz-Zusatzunwucht');
   % createfigure_Phasenlage_JM_v06([0,F_GL_zusatz], [0,F_WL_zusatz], 0 ,'Zusatzunwucht');
 
    F_GL_Ampl = abs(F_GL_zusatz);
    F_WL_Ampl = abs(F_WL_zusatz);

    Zusatzunwuchtsmatrix = [z1, Unwucht, phi];
%--------------------------------------------------------------------------

%     F_GL_Unwuchtantwort = Gleichlauf_FGL(:,1) - c'*F_GL_trenn(1);
%     F_WL_Unwuchtantwort = Gleichlauf_FWL(:,1) - c'*F_WL_trenn(1);

    F_GL_Unwuchtantwort = d'*F_GL_trenn(2);
    F_WL_Unwuchtantwort = d'*F_WL_trenn(2);

    F_GL_Unwuchtantwort_Amp = abs(F_GL_Unwuchtantwort);
    phi_GL_Unwuchtantwort = atan2(imag(F_GL_Unwuchtantwort),real(F_GL_Unwuchtantwort));
    F_WL_Unwuchtantwort_Amp = abs(F_WL_Unwuchtantwort);
    phi_WL_Unwuchtantwort = atan2(imag(F_WL_Unwuchtantwort),real(F_WL_Unwuchtantwort));

%--------------------------------------------------------------------------
%Kontrolldiagramm:
%createfigure_Kraftamplitude_Drehzahlen_Messung(Drehzahlen_zU, [F_GL_Unwuchtantwort_Amp, F_WL_Unwuchtantwort_Amp], 'Zusatzunwucht');
%--------------------------------------------------------------------------

save Unwuchtschaetzung_JM_v11.mat OmegaExakt Unwucht z1 phi F_GL_Ampl phi_1 F_WL_Ampl phi_2 F_GL_Unwuchtantwort phi_GL_Unwuchtantwort F_GL_Unwuchtantwort_Amp F_WL_Unwuchtantwort phi_WL_Unwuchtantwort F_WL_Unwuchtantwort_Amp;
save ZusatzUnwuchtsmatrix.mat Zusatzunwuchtsmatrix;
end