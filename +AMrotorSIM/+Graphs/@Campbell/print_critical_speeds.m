function print_critical_speeds(obj)
% Prints the crossing of the first harmonic with the eigenfrequencies
%
%    :return: Display of the first harmonic with the eigenfrequencies in the Command Window

% Licensed under GPL-3.0-or-later, check attached LICENSE file

omega = obj.experimentCampbell.get_omega();
EW = obj.experimentCampbell.get_eigenvalues();

for i = 1:size(EW.forward,1)
    criticalSpeed.forward(i) = obj.get_zero_crossing(omega,imag(EW.forward(i,:))-omega);
end
for i = 1:size(EW.backward,1)
    criticalSpeed.backward(i) = obj.get_zero_crossing(omega,imag(EW.backward(i,:))-omega);
end

disp('Critical  rotation speeds')
if ~all(isnan(criticalSpeed.forward))
    disp('Modes with forward-whirl')
end
n_moden=length(criticalSpeed.forward);
for s=1:n_moden
    if ~isnan(criticalSpeed.forward(s)) %remove NaN values
        disp([num2str(s),'. Mode (forward): at ', num2str(criticalSpeed.forward(s)*60/2/pi), ' 1/min'])
    end
end
% disp(' ')

if ~all(isnan(criticalSpeed.backward))
    disp('Modes with backward-whirl')
end
n_moden=length(criticalSpeed.backward);
for s=1:n_moden
    if ~isnan(criticalSpeed.backward(s))
        disp([num2str(s),'. Mode (backward): at ', num2str(criticalSpeed.backward(s)*60/2/pi), ' 1/min'])
    end
end

if all(isnan(criticalSpeed.forward)) && all(isnan(criticalSpeed.backward))
    disp('No intersections between the first harmonic and the eigenfrequencies.')
end

disp(' ')

end