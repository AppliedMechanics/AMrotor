function [F_GL_rest, F_WL_rest]=Rest_UnwuchtSchaetzer_JM_v12(Pfad_rU, Drehzahlen_rU)
%Rest-Unwucht Schätzer JM 28.05.2014
%Lavla-Rotor als Grundlage
%
%Betrachtung nur von Gleichlauf!!
%
% - auf Hochlauf ohne Unwucht anwenden. 

clc
close all

Wellenlaenge = 0.59; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz = 63.5*2*pi;   %Eigenfrequenz des Rotors in rad/sec.

for i1=1:length(Drehzahlen_rU)
    Name=[Pfad_rU, 'Messdaten/Hochlauf2-',num2str(Drehzahlen_rU(i1)),'.mat'];
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
 
 %-------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:
    %Unwucht = 0.5*(abs(F_GL_trenn(2))+abs(F_WL_trenn(2)))/Eigenfrequenz^2;
    %Unwucht = abs(F_GL_trenn(2)+F_WL_trenn(2))/Eigenfrequenz^2;
    Unwucht_komplex = (F_GL_trenn(2)+F_WL_trenn(2))/Eigenfrequenz^2;
    Unwucht = abs(Unwucht_komplex);
    
    %Position der Unwucht über beide Momentenggw.:
    pos_rel = abs(F_WL_trenn(2))/(abs(F_GL_trenn(2))+abs(F_WL_trenn(2)));
    z1 = pos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    %phi_1 = atan2(imag(F_GL_trenn(2)),real(F_GL_trenn(2)));
    %phi_2 = atan2(imag(F_WL_trenn(2)),real(F_WL_trenn(2)));
    
    %phi = 0.5*(phi_1+phi_2); %gemittelte Phase
    phi = phase(Unwucht);
    
    %createfigure_Phasenlage_JM_v06([0,F_GL_trenn(1)], [0,F_WL_trenn(1)], 0 ,'Kupplungsversatz-Restunwucht');
    %createfigure_Phasenlage_JM_v06([0,F_GL_trenn(2)], [0,F_WL_trenn(2)], 0 ,'Äquivalente-Restunwucht');
%--------------------------------------------------------------------------
 
%     F_GL_Unwuchtantwort = Gleichlauf_FGL(:,1) - c'*F_GL_trenn(1);
%     F_WL_Unwuchtantwort = Gleichlauf_FWL(:,1) - c'*F_WL_trenn(1);

    F_GL_Unwuchtantwort = d'*F_GL_trenn(2);
    F_WL_Unwuchtantwort = d'*F_WL_trenn(2);

    F_GL_Unwuchtantwort_Amp = abs(F_GL_Unwuchtantwort);
    phi_GL_Unwuchtantwort = atan2(imag(F_GL_Unwuchtantwort),real(F_GL_Unwuchtantwort));
    F_WL_Unwuchtantwort_Amp = abs(F_WL_Unwuchtantwort);
    phi_WL_Unwuchtantwort = atan2(imag(F_WL_Unwuchtantwort),real(F_WL_Unwuchtantwort));

    Restunwuchtsmatrix = [z1, Unwucht, phi];
    
    F_GL_rest = F_GL_trenn(2);
    F_WL_rest = F_WL_trenn(2);
%--------------------------------------------------------------------------
%Kontrolldiagramm: 
%createfigure_Kraftamplitude_Drehzahlen_Messung(Drehzahlen_rU, [F_GL_Unwuchtantwort_Amp, F_WL_Unwuchtantwort_Amp], 'Restunwucht');
%--------------------------------------------------------------------------
%Sichern

save RestUnwuchtschaetzung_JM_v11.mat OmegaExakt Unwucht z1 phi F_GL_Unwuchtantwort phi_GL_Unwuchtantwort F_GL_Unwuchtantwort_Amp F_WL_Unwuchtantwort phi_WL_Unwuchtantwort F_WL_Unwuchtantwort_Amp F_GL_rest F_WL_rest;
save RestUnwuchtsmatrix.mat Restunwuchtsmatrix;
end

