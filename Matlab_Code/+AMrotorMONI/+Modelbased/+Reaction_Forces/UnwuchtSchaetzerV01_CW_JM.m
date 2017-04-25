function [z1, Unwucht, phi] = UnwuchtSchaetzerV01_CW_JM(data)
%UNWUCHTSCHAETZERV01-CW-JM Summary 


Wellenlaenge = 0.59; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz = 63.5*2*pi;   %Eigenfrequenz des Rotors in rad/sec.

for i1=1:size(data(),1); %aus JM Rest_Unwucht_Schätzer
%Diese Funktion muss noch überarbeitet werden, da der Fourier Fit der
%Lagerkräfte nicht die Beste Lösung ist!!!
[~,OmegaExakt(i1),Gleichlauf_FGL(i1,:),Gegenlauf_FGL(i1,:), Gleichlauf_FWL(i1,:), Gegenlauf_FWL(i1,:)] = AnalysiereEO_3SensorenJM_v04(squeeze(data(i1,:,:)));
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
    phi = phase(Unwucht_komplex);


end

