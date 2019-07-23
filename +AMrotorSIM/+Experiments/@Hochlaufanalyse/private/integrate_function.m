function dZ = integrate_function(t,Z,rpm_span,t_span, rotorsystem)

rpm_curr = rpm_span(1) + (rpm_span(2)-rpm_span(1)) / (t_span(2)-t_span(1)) * t; % aktuelle Drehzahl
Omega_curr = rpm_curr/60*2*pi;

[M,C,G,K] = rotorsystem.assemble_system_matrices(rpm_curr); % Systemmatrizen sind in jedem Zeitschritt anders wegen Seal und Bearing rpm-abhaengig
D = C + Omega_curr*G;

ndof = length(M);
Z(2*ndof) = Omega_curr; % node on the right is driven with current Omega

%% Loadvector
h_ges = rotorsystem.compute_system_load_ss(t,Z(1:2*ndof)); 

%% DGL 
% sollte schneller sein als alte Berechnung mit Vorabberechnung der
% Systemmatritzen, da sonst in jedem Zeitschritt die volle M-Matrix
% invertiert werden würde
Z1 = Z(1 : ndof);
Z2 = Z(ndof+1: 2*ndof);
dZ1 = Z2;
dZ2 = M \ (-K*Z1 -D*Z2 +h_ges(end/2+1:end));
dZ = [dZ1; dZ2];

end

