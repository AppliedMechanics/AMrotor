function [Revisedimbalancemarix,Differentialimbalancematrix,RevisedKupplungsversatz,DifferentialKupplungsversatz]=Revisional_Imbalance_Approximator(obj,datasetNeu, F_GL_rest, F_WL_rest)
% Berechnet gekoppelten Schlag+Unwucht und Kuplungsveratz aus Messwerten
% dataset und vergleicht diese mit der Initialten Messung
% Betrachtung nur von Gleichlauf!!

% Paraeter Importieren
Wellenlaenge=obj.cnfg.Lagerabstand; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz =obj.cnfg.Eigenfrequenz;   %Eigenfrequenz des Rotors in rad/sec.


%% Fourier transforamtion vom aktulellen Messwerte-Paket
for i1=1:size(datasetNeu,1)
    Input=permute(datasetNeu,[2 3 1]);%Macht 3x10x10000 zu 10x10000x3
    [~,OmegaExakt(i1),Gleichlauf_FGL(i1,:),Gegenlauf_FGL(i1,:), Gleichlauf_FWL(i1,:), Gegenlauf_FWL(i1,:)] = AnalysiereEO_3SensorenJM_v04(obj,Input(:,:,i1));
end


%% Aufstellen des Gleichungssystem
eta = OmegaExakt./Eigenfrequenz;

c = 1./(1-eta.^2);
d = eta.^2./(1-eta.^2); % quadratischer Anteil

A = [c', d'];

 F_GL_trenn = A\Gleichlauf_FGL(:,1);      %Überbestimmtes Gleichungssystem lösen.
 F_WL_trenn = A\Gleichlauf_FWL(:,1);
 %Erste Zeile von F_GL_trenn entspricht Kupplungsversatz
 %Zweite Zeile entspricht den quadratisch skalierenden Anteilen
 
 
 %Abziehen der Kräfte aus dem Initialisierungslauf zur Berechnung der
 %Diefferenzunwucht/DifferenzKuplungsveratz
 F_GL_zusatz = F_GL_trenn - F_GL_rest;
 F_WL_zusatz = F_WL_trenn - F_WL_rest;

 
 
%% ------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:;
    DifferenzUnwucht = abs(F_GL_zusatz(2)+F_WL_zusatz(2))/Eigenfrequenz^2;
    
    %Position der Unwucht über beide Momentenggw.:
    Differenzpos_rel = abs(F_WL_zusatz(2))/(abs(F_GL_zusatz(2))+abs(F_WL_zusatz(2)));
    Differenzz1 = Differenzpos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    Differenzphi_1 = atan2(imag(F_GL_zusatz(2)),real(F_GL_zusatz(2)));
    Differenzphi_2 = atan2(imag(F_WL_zusatz(2)),real(F_WL_zusatz(2)));
    
    Differenzphi = 0.5*(Differenzphi_1+Differenzphi_2); %gemittelte Phase
    
    % Ausgabeformat Unwuchtsmatrix
    Differentialimbalancematrix = [Differenzz1, DifferenzUnwucht, Differenzphi];
 
    
    
%--------------------------------------------------------------------------
    
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:;
    NeueUnwucht = abs(F_GL_trenn(2)+F_WL_trenn(2))/Eigenfrequenz^2;
    
    %Position der Unwucht über beide Momentenggw.:
    Neuepos_rel = abs(F_WL_trenn(2))/(abs(F_GL_trenn(2))+abs(F_WL_trenn(2)));
    Neuez1 = Neuepos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    Neuephi_1 = atan2(imag(F_GL_trenn(2)),real(F_GL_trenn(2)));
    Neuephi_2 = atan2(imag(F_WL_trenn(2)),real(F_WL_trenn(2)));
    
    Neuephi = 0.5*(Neuephi_1+Neuephi_2); %gemittelte Phase
    
    % Ausgabeformat neue Uwucht 
    Revisedimbalancemarix = [Neuez1, NeueUnwucht, Neuephi];
   
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz Differenz
    Differenz_BKV = abs(F_GL_zusatz(1)+F_WL_zusatz(1));

    % Z Position Kupplungsversatz Differenz durch Momentengleichgewicht
    Differenzpos_rel_BKV = abs(F_WL_zusatz(1))/(abs(F_GL_zusatz(1))+abs(F_WL_zusatz(1)));
    Differenzz1_BKV = Differenzpos_rel_BKV*Wellenlaenge;

    % Phase Kupplungsveratz Differenz
    Differenzphi_1_BKV = atan2(imag(F_GL_zusatz(1)),real(F_GL_zusatz(1)));
    Differenzphi_2_BKV = atan2(imag(F_WL_zusatz(1)),real(F_WL_zusatz(1)));
    
    Differenzphi_BKV = 0.5*(Differenzphi_1_BKV+Differenzphi_2_BKV); %gemittelte Phase
    
    % Ausgabeformat Kupplungsversatz Differenz
    DifferentialKupplungsversatz = [Differenzz1_BKV, Differenz_BKV, Differenzphi_BKV];
    
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz neue Messung
    NeuBKV = abs(F_GL_trenn(1)+F_WL_trenn(1));
    
    % Z Position neuer Kupplungsversatz durch Momentengleichgewicht
    Neu_pos_rel_BKV = abs(F_WL_trenn(1))/(abs(F_GL_trenn(1))+abs(F_WL_trenn(1)));
    Neu_z1_BKV = Neu_pos_rel_BKV*Wellenlaenge;
    
    % Phase neuer Kupplungsveratz
    Neu_phi_1_BKV = atan2(imag(F_GL_trenn(1)),real(F_GL_trenn(1)));
    Neu_phi_2_BKV = atan2(imag(F_WL_trenn(1)),real(F_WL_trenn(1)));
    
    Neu_phi_BKV = 0.5*(Neu_phi_1_BKV+Neu_phi_2_BKV); %gemittelte Phase

    % Ausgabeformat neuer Kupplungsversatz
    RevisedKupplungsversatz = [Neu_z1_BKV, NeuBKV, Neu_phi_BKV];

end