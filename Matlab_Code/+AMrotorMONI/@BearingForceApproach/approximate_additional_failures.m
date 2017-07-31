function [Revisedimbalancemarix,Differentialimbalancematrix,RevisedKupplungsversatz,DifferentialKupplungsversatz]=approximate_additional_failures(obj,datasetNeu, F_L1_rest, F_L2_rest)
% Berechnet gekoppelten Schlag+Unwucht und Kuplungsveratz aus Messwerten
% dataset und vergleicht diese mit der Initialten Messung
% Betrachtung nur von Gleichlauf!!

% Paraeter Importieren
Wellenlaenge=obj.cnfg.Lagerabstand; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz =obj.cnfg.Eigenfrequenz;   %Eigenfrequenz des Rotors in rad/sec.


%% Fourier transforamtion vom aktulellen Messwerte-Paket
for i1=1:size(datasetNeu,1)
    Input=permute(datasetNeu,[2 3 1]);%Macht 3x10x10000 zu 10x10000x3
    [~,OmegaExakt(i1),Gleichlauf_FL1(i1,:),Gegenlauf_FL1(i1,:), Gleichlauf_FL2(i1,:), Gegenlauf_FL2(i1,:)] = analyse_force_fourier_coeff(obj,Input(:,:,i1));
end


%% Aufstellen des Gleichungssystem
eta = OmegaExakt./Eigenfrequenz;

c = 1./(1-eta.^2);
d = eta.^2./(1-eta.^2); % quadratischer Anteil

A = [c', d'];

 F_L1_trenn = A\Gleichlauf_FL1(:,1);      %Überbestimmtes Gleichungssystem lösen.
 F_L2_trenn = A\Gleichlauf_FL2(:,1);
 %Erste Zeile von F_L1_trenn entspricht Kupplungsversatz
 %Zweite Zeile entspricht den quadratisch skalierenden Anteilen
 
 
 %Abziehen der Kräfte aus dem Initialisierungslauf zur Berechnung der
 %Diefferenzunwucht/DifferenzKuplungsveratz
 F_L1_zusatz = F_L1_trenn - F_L1_rest;
 F_L2_zusatz = F_L2_trenn - F_L2_rest;

 
 
%% ------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:;
    DifferenzUnwucht = abs(F_L1_zusatz(2)+F_L2_zusatz(2))/Eigenfrequenz^2;
    
    %Position der Unwucht über beide Momentenggw.:
    Differenzpos_rel = abs(F_L2_zusatz(2))/(abs(F_L1_zusatz(2))+abs(F_L2_zusatz(2)));
    Differenzz1 = Differenzpos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    Differenzphi_1 = atan2(imag(F_L1_zusatz(2)),real(F_L1_zusatz(2)));
    Differenzphi_2 = atan2(imag(F_L2_zusatz(2)),real(F_L2_zusatz(2)));
    
    Differenzphi = 0.5*(Differenzphi_1+Differenzphi_2); %gemittelte Phase
    
    % Ausgabeformat Unwuchtsmatrix
    Differentialimbalancematrix = [Differenzz1, DifferenzUnwucht, Differenzphi];
 
    
    
%--------------------------------------------------------------------------
    
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:;
    NeueUnwucht = abs(F_L1_trenn(2)+F_L2_trenn(2))/Eigenfrequenz^2;
    
    %Position der Unwucht über beide Momentenggw.:
    Neuepos_rel = abs(F_L2_trenn(2))/(abs(F_L1_trenn(2))+abs(F_L2_trenn(2)));
    Neuez1 = Neuepos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    Neuephi_1 = atan2(imag(F_L1_trenn(2)),real(F_L1_trenn(2)));
    Neuephi_2 = atan2(imag(F_L2_trenn(2)),real(F_L2_trenn(2)));
    
    Neuephi = 0.5*(Neuephi_1+Neuephi_2); %gemittelte Phase
    
    % Ausgabeformat neue Uwucht 
    Revisedimbalancemarix = [Neuez1, NeueUnwucht, Neuephi];
   
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz Differenz
    Differenz_BKV = abs(F_L1_zusatz(1)+F_L2_zusatz(1));

    % Z Position Kupplungsversatz Differenz durch Momentengleichgewicht
    Differenzpos_rel_BKV = abs(F_L2_zusatz(1))/(abs(F_L1_zusatz(1))+abs(F_L2_zusatz(1)));
    Differenzz1_BKV = Differenzpos_rel_BKV*Wellenlaenge;

    % Phase Kupplungsveratz Differenz
    Differenzphi_1_BKV = atan2(imag(F_L1_zusatz(1)),real(F_L1_zusatz(1)));
    Differenzphi_2_BKV = atan2(imag(F_L2_zusatz(1)),real(F_L2_zusatz(1)));
    
    Differenzphi_BKV = 0.5*(Differenzphi_1_BKV+Differenzphi_2_BKV); %gemittelte Phase
    
    % Ausgabeformat Kupplungsversatz Differenz
    DifferentialKupplungsversatz = [Differenzz1_BKV, Differenz_BKV, Differenzphi_BKV];
    
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz neue Messung
    NeuBKV = abs(F_L1_trenn(1)+F_L2_trenn(1));
    
    % Z Position neuer Kupplungsversatz durch Momentengleichgewicht
    Neu_pos_rel_BKV = abs(F_L2_trenn(1))/(abs(F_L1_trenn(1))+abs(F_L2_trenn(1)));
    Neu_z1_BKV = Neu_pos_rel_BKV*Wellenlaenge;
    
    % Phase neuer Kupplungsveratz
    Neu_phi_1_BKV = atan2(imag(F_L1_trenn(1)),real(F_L1_trenn(1)));
    Neu_phi_2_BKV = atan2(imag(F_L2_trenn(1)),real(F_L2_trenn(1)));
    
    Neu_phi_BKV = 0.5*(Neu_phi_1_BKV+Neu_phi_2_BKV); %gemittelte Phase

    % Ausgabeformat neuer Kupplungsversatz
    RevisedKupplungsversatz = [Neu_z1_BKV, NeuBKV, Neu_phi_BKV];

end