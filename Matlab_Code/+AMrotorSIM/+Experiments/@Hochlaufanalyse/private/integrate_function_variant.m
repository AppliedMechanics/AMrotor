function dZ = integrate_function_variant(t,Z,rpm_span,t_span, rotorsystem)
rpm_curr = rpm_span(1) + (rpm_span(2)-rpm_span(1)) / (t_span(2)-t_span(1)) * t; % aktuelle Drehzahl
omega_curr = rpm_curr/60*2*pi;

[M,C,G,K] = rotorsystem.assemble_system_matrices(rpm_curr); % Systemmatrizen sind in jedem Zeitschritt anders
D = C + omega_curr*G;

%% Loadvector
h_ges = rotorsystem.compute_system_load_variant(t,Z,omega_curr); 

%% DGL 
% sollte schneller sein als alte Berechnung mit Vorabberechnung der
% Systemmatritzen, da sonst in jedem Zeitschritt die volle M-Matrix
% invertiert werden würde
Z1 = Z(1:end/2);
Z2 = Z(end/2+1:end);
dZ1 = Z2;
dZ2 = M \ (-K*Z1 -D*Z2 +h_ges(end/2+1:end));
dZ = [dZ1; dZ2];

end

