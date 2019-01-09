%% Magnetlager Kennwerte

% Reglerparameter
mag.Kp=8000%1e9;% A/m
mag.Ki=1500%1e12;  % A/m*s
mag.Kd=5%-1e4;   % A*s/m

% Strombegrenzung
mag.I_max = 5.0; 						%[A] maximaler Verstärkerstrom
mag.I_min = 0.0; 						%[A] minimaler Verstärkerstrom

%Vormagnetisierung
mag.Iv = 2.5;    						%[A] Vormagnetisierungsstrom

% % Materialparameter Magnetlager
% Aus Kennlinien Katrin Baumann: k = 3.63e-06 Nm^2/A^2
mag.kMag = 3.63e-6%(4*pi*1e-7)*(2.9e-4)*(2*104)^2*cos(22.5/180*pi)/4; %TU-DA, Geometrie des Magnetlagers
mag.s0 = 780e-6; % Ruheluftspalt
mag.k_i = 59.855%+mag.kMag*4*mag.Iv/mag.s0^2; % N/A
mag.k_s = -1.9184e5%+mag.kMag*4*mag.Iv^2/mag.s0^3; % N/m %negativ nach TU-DA, positiv nach Insam