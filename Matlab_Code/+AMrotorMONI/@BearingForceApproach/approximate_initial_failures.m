function [AnfangsUnwuchtsmatrix,F_L1_rest,F_L2_rest,AnfangsKupplungsversatz]=approximate_initial_failures(obj,dataset)
% Berechnet gekoppelte Unwucht+Schlag und Kupplungsversatz
% Betrachtung nur von Gleichlauf!!

% Parameter Importieren 
Wellenlaenge=obj.cnfg.Lagerabstand; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz =obj.cnfg.Eigenfrequenz;   %Eigenfrequenz des Rotors in rad/sec.


%% Fourier transformation vom aktulellen Messwerte-Paket
Schluessel=keys(dataset);
for i1=1:size(keys(dataset),2)
    temp=dataset(Schluessel{i1});
    Zeit=temp('time');
    Tacho=temp('omega');
    phi=temp('phi');
    Kraft_L1_1=temp('F_x (Lager 1)');
    Kraft_L1_2=temp('F_y (Lager 1)');
    Kraft_L2_1=temp('F_x (Lager 2)');
    Kraft_L2_2=temp('F_y (Lager 2)');
    
    [~,OmegaExakt(i1),Gleichlauf_FL1(i1,:),Gegenlauf_FL1(i1,:), Gleichlauf_FL2(i1,:), Gegenlauf_FL2(i1,:)] = analyse_force_fourier_coeff(obj,Zeit,Tacho,phi,Kraft_L1_1,Kraft_L1_2,Kraft_L2_1,Kraft_L2_2);
end


%% Aufstellen des Gleichungssystem
eta = OmegaExakt./Eigenfrequenz;

c = 1./(1-eta.^2);
d = eta.^2./(1-eta.^2);

A = [c', d'];

 F_L1_trenn = A\Gleichlauf_FL1(:,1);      %Überbestimmtes Gleichungssystem lösen.
 F_L2_trenn = A\Gleichlauf_FL2(:,1);
 
 
 %Erste Zeile von F_L1_trenn entspricht Kupplungsversatz
 %Zweite Zeile entspricht den quadratisch skalierenden Anteilen
 
%% ------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:
    
    Unwucht = abs(F_L1_trenn(2)+F_L2_trenn(2))/Eigenfrequenz^2;   % BA JM s 15 gl 25
    
    %Position der Unwucht über beide Momentenggw.:
    pos_rel = abs(F_L2_trenn(2))/(abs(F_L1_trenn(2))+abs(F_L2_trenn(2)));
    z1 = pos_rel*Wellenlaenge;
   
    %Phase der Unwucht
    phi_1 = atan2(imag(F_L1_trenn(2)),real(F_L1_trenn(2)));
    phi_2 = atan2(imag(F_L2_trenn(2)),real(F_L2_trenn(2)));
    
    phi = 0.5*(phi_1+phi_2); %gemittelte Phase
    
    
    AnfangsUnwuchtsmatrix = [z1, Unwucht, phi];
%% ------------------------------------------------------------------------ 
    % Kupplungsversatz
    BKV = abs(F_L1_trenn(1)+F_L2_trenn(1));
    
    % Position des Kupplungsversatz über Momentenggw:
    pos_rel_BKV = abs(F_L2_trenn(1))/(abs(F_L1_trenn(1))+abs(F_L2_trenn(1)));
    z1_BKV = pos_rel_BKV*Wellenlaenge;

    % Phase Kupplungsversatz
    phi_1_BKV = atan2(imag(F_L1_trenn(1)),real(F_L1_trenn(1)));
    phi_2_BKV = atan2(imag(F_L2_trenn(1)),real(F_L2_trenn(1)));
    
    phi_BKV = 0.5*(phi_1_BKV+phi_2_BKV); %gemittelte Phase
    
    
    AnfangsKupplungsversatz = [z1_BKV, BKV, phi_BKV];
%% ------------------------------------------------------------------------   
    
    % Abspeichern der Kaftvektoren vom Initialsierungslauf für Differenz
    % Lauf
    F_L1_rest = F_L1_trenn;
    F_L2_rest = F_L2_trenn;

end
