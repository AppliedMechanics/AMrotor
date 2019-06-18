function [Bearing1_Revisionalforce,Bearing2_Revisionalforce,Bearing1_Differentialforce,Bearing2_Differentialforce,Revisedimbalancemarix,Differentialimbalancematrix,RevisedKupplungsversatz,DifferentialKupplungsversatz]=approximate_additional_failures(obj,datasetNeu, F_L1_rest, F_L2_rest)
% Berechnet gekoppelten Schlag+Unwucht und Kuplungsveratz aus Messwerten
% dataset und vergleicht diese mit der Initialten Messung
% Betrachtung nur von Gleichlauf!!

% Paraeter Importieren
Wellenlaenge=obj.cnfg.Lagerabstand; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz =obj.cnfg.Eigenfrequenz; %Eigenfrequenz des Rotors in rad/sec.
zLinkesLager = obj.cnfg.zLinkesLager;


%% Fourier transforamtion vom aktulellen Messwerte-Paket
Schluessel=keys(datasetNeu);
for i1=1:(size(keys(datasetNeu),2))
    temp=datasetNeu(Schluessel{i1});
    Zeit=temp('time');
    Tacho=temp('n');
    phi=temp('Phi');
    Kraft_L1_1=temp('F_x (Kraftsensor links)');
    Kraft_L1_2=temp('F_y (Kraftsensor links)');
    Kraft_L2_1=temp('F_x (Kraftsensor rechts)');
    Kraft_L2_2=temp('F_y (Kraftsensor rechts)');
    [Drehzahlmess(i1),OmegaExakt(i1),Gleichlauf_FL1(i1,:),Gegenlauf_FL1(i1,:), Gleichlauf_FL2(i1,:), Gegenlauf_FL2(i1,:),StatischeKraft_FL1(i1,:),StatischeKraft_FL2(i1,:),fourier(i1)] = analyse_force_fourier_coeff(obj,Zeit,Tacho,phi,Kraft_L1_1,Kraft_L1_2,Kraft_L2_1,Kraft_L2_2);
end


%% Aufstellen des Gleichungssystem
eta = 2*pi/60*Drehzahlmess./Eigenfrequenz;

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
    Differenzpos_rel_Unw = abs(F_L2_zusatz(2))/(abs(F_L1_zusatz(2))+abs(F_L2_zusatz(2)));
    Differenzz1_Unw = Differenzpos_rel_Unw*Wellenlaenge + zLinkesLager;
   
    %Phase der Unwucht
    vektorDifferenzUnwucht = F_L1_zusatz(2)+F_L2_zusatz(2);
    Differenzphi_Unw = atan2(imag(vektorDifferenzUnwucht),real(vektorDifferenzUnwucht));
    
    % Ausgabeformat Unwuchtsmatrix
    Differentialimbalancematrix = [Differenzz1_Unw, DifferenzUnwucht, Differenzphi_Unw];
 
    
    
%--------------------------------------------------------------------------
    
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:;
    NeueUnwucht = abs(F_L1_trenn(2)+F_L2_trenn(2))/Eigenfrequenz^2;
    
    %Position der Unwucht über beide Momentenggw.:
    Neuepos_rel_Unw = abs(F_L2_trenn(2))/(abs(F_L1_trenn(2))+abs(F_L2_trenn(2)));
    Neuez1_Unw = Neuepos_rel_Unw*Wellenlaenge + zLinkesLager;
   
    %Phase der Unwucht
    vektorNeueUnwucht = F_L1_trenn(2)+F_L2_trenn(2);
    Neuephi_Unw = atan2(imag(vektorNeueUnwucht),real(vektorNeueUnwucht));
    
    % Ausgabeformat neue Uwucht 
    Revisedimbalancemarix = [Neuez1_Unw, NeueUnwucht, Neuephi_Unw];
   
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz Differenz
    Differenz_BKV = abs(F_L1_zusatz(1)+F_L2_zusatz(1));

    % Z Position Kupplungsversatz Differenz durch Momentengleichgewicht
    Differen_zpos_rel_BKV = abs(F_L2_zusatz(1))/(abs(F_L1_zusatz(1))+abs(F_L2_zusatz(1)));
    Differenz_z1_BKV = Differen_zpos_rel_BKV*Wellenlaenge + zLinkesLager;

    % Phase Kupplungsveratz Differenz
    vektorDifferenz_BKV =F_L1_zusatz(1)+F_L2_zusatz(1);
    Differenz_phi_BKV = atan2(imag(vektorDifferenz_BKV),real(vektorDifferenz_BKV));
    
    % Ausgabeformat Kupplungsversatz Differenz
    DifferentialKupplungsversatz = [Differenz_z1_BKV, Differenz_BKV, Differenz_phi_BKV];
    
    
    
%% ------------------------------------------------------------------------

    % Kupplungsversatz neue Messung
    NeuBKV = abs(F_L1_trenn(1)+F_L2_trenn(1));
    
    % Z Position neuer Kupplungsversatz durch Momentengleichgewicht
    Neu_pos_rel_BKV = abs(F_L2_trenn(1))/(abs(F_L1_trenn(1))+abs(F_L2_trenn(1)));
    Neu_z1_BKV = Neu_pos_rel_BKV*Wellenlaenge + zLinkesLager;
    
    % Phase neuer Kupplungsveratz
    vektorNeuBKV = F_L1_trenn(1)+F_L2_trenn(1);
    Neu_phi_BKV = atan2(imag(vektorNeuBKV),real(vektorNeuBKV));
    
    % Ausgabeformat neuer Kupplungsversatz
    RevisedKupplungsversatz = [Neu_z1_BKV, NeuBKV, Neu_phi_BKV];
    
    
%% ------------------------------------------------------------------------

    % Datensätze für Übergabe an gekoppelte Brechnung
    
    Bearing1_Revisionalforce=F_L1_trenn;
    Bearing2_Revisionalforce=F_L2_trenn;
    Bearing1_Differentialforce=F_L1_zusatz;
    Bearing2_Differentialforce=F_L2_zusatz;

end