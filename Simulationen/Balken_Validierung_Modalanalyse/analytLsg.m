% Vibration of Euler-Bernoulli-Beam - modal analysis
% analytical solution according to Genta Vibration Dynamics and Control p.
% 286, 2008
% Note that the analytic solution is given for Euler-Bernoulli beams.
% However, the simulation is based on Timoshenko's beam theory. For
% Timoshenko, the beam is softer, which means lower EF than in the
% Euler-Bernoulli theory.
clear, %close all

Config_Sim_Balken

boundaryCondition = 'free-free';
% boundaryCondition = 'supported-free';
% boundaryCondition = 'clamped-free';
% boundaryCondition = 'supported-supported';
% boundaryCondition = 'supported-clamped';
% boundaryCondition = 'clamped-clamped';
numberEigenfrequencies = 6;
beamLength = beamLength; % aus Config
area = pi*radius^2; % aus Config
E = cnfg.cnfg_rotor.material.e_module;
Iy = pi * radius^4 / 4;
rho = cnfg.cnfg_rotor.material.density;

beta = zeros(1,numberEigenfrequencies); % beta without i=0 ( rigid body mode)
z = linspace(0,beamLength,1e3);
zeta = z/beamLength;
q = zeros(length(z),numberEigenfrequencies);

switch boundaryCondition
    case 'free-free'
        beta(1:4) = [4.730, 7.853, 10.996, 14.137];
        for i = 5: numberEigenfrequencies
            beta(i) = (i+1/2)*pi;
        end
        for i = 1 : numberEigenfrequencies
            N = (sin(beta(i))-sinh(beta(i))) / (-cos(beta(i))+cosh(beta(i)));
            q(:,i) = 1/(2*N) * (sin(beta(i)*zeta) + sinh(beta(i)*zeta) + N*( cos(beta(i)*zeta) + cosh(beta(i)*zeta) ) );
        end
    case 'supported-free'
        for i = 1: numberEigenfrequencies
            beta(i) = (i+1/4)*pi;
        end
        for i = 1 : numberEigenfrequencies
            q(:,i) = 1/(2*sin(beta(i))) * (sin(beta(i)*zeta) + sin(beta(i))/sinh(beta(i)) * sinh(beta(i)*zeta) );
        end
    case 'clamped-free'
        beta(1:4) = [1.875, 4.694, 7.855, 10.996];
        for i = 5: numberEigenfrequencies
            beta(i) = (i-1/2)*pi;
        end
        for i = 1 : numberEigenfrequencies
            N1 = (sin(beta(i))+sinh(beta(i))) / (cos(beta(i))+cosh(beta(i)));
            N2 = sin(beta(i)) - sinh(beta(i)) - N1*(cos(beta(i)) - cosh(beta(i)));
            q(:,i) = 1/N2 * ( sin(beta(i)*zeta) - sinh(beta(i)*zeta) - N1*( cos(beta(i)*zeta) - cosh(beta(i)*zeta) ) );
        end
    case 'supported-supported'
        for i = 1: numberEigenfrequencies
            beta(i) = i*pi;
        end
        for i = 1 : numberEigenfrequencies
            q(:,i) = sin(i*pi*zeta);
        end
    case 'supported-clamped'
        beta(1:4) = [3.926, 7.069, 10.210, 13.352];
        for i = 5: numberEigenfrequencies
            beta(i) = (i+1/4)*pi;
        end
        for i = 1 : numberEigenfrequencies
            bracket = sin(beta(i)*zeta) - sin(beta(i))/sinh(beta(i))*sinh(beta(i)*zeta);
            N = max(bracket);
            q(:,i) = 1/N * bracket;
        end
    case 'clamped-clamped'
        beta(1:4) = [4.730, 7.853, 10.996, 14.137];
        for i = 5: numberEigenfrequencies
            beta(i) = (i+1/2)*pi;
        end
        for i = 1 : numberEigenfrequencies
            N1 = (sin(beta(i)) - sinh(beta(i))) / (cos(beta(i)) - cosh(beta(i)));
            braces = sin(beta(i)*zeta) - sinh(beta(i)*zeta) - N1 * ( cos(beta(i)*zeta) - cosh(beta(i)*zeta) );
            N2 = max(braces);
            q(:,i) = 1/N2 * braces;
        end
end

omega = beta.^2/beamLength^2 * sqrt(E*Iy / rho / area);



% plot der Eigenformen
fig = figure;
hold on
disp('Eigenfrequenzen des Balkens');
disp(['Lagerung: ', boundaryCondition]);
for i = 1:numberEigenfrequencies
    EF_Hz_string_coarse = [num2str(omega(i)/2/pi,'%0.f'),' Hz'];
    EF_Hz_string_fine = [num2str(omega(i)/2/pi),' Hz'];
    plot(z,q(:,i),'DisplayName',EF_Hz_string_coarse);
    disp([num2str(i),'. EF: ',EF_Hz_string_fine]);
end
grid on
legend
