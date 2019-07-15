function print_critical_speeds(obj)
% prints the crossing of the first harmonic with eigenfrequencies

omega = obj.experimentCampbell.get_omega();
EW = obj.experimentCampbell.get_eigenvalues();

for i = 1:size(EW.forward,1)
    criticalSpeed.forward(i) = obj.get_zero_crossing(omega,imag(EW.forward(i,:))-omega);
end
for i = 1:size(EW.backward,1)
    criticalSpeed.backward(i) = obj.get_zero_crossing(omega,imag(EW.backward(i,:))-omega);
end

disp('Kritsche Drehzahlen')
if ~all(isnan(criticalSpeed.forward))
    disp('Moden mit forward-whirl')
end
n_moden=length(criticalSpeed.forward);
for s=1:n_moden
    if ~isnan(criticalSpeed.forward(s)) %remove NaN values
        disp([num2str(s),'. Mode (forward): bei ', num2str(criticalSpeed.forward(s)*60/2/pi), ' 1/min'])
    end
end
% disp(' ')

if ~all(isnan(criticalSpeed.backward))
    disp('Moden mit backward-whirl')
end
n_moden=length(criticalSpeed.backward);
for s=1:n_moden
    if ~isnan(criticalSpeed.backward(s))
        disp([num2str(s),'. Mode (backward): bei ', num2str(criticalSpeed.backward(s)*60/2/pi), ' 1/min'])
    end
end

if all(isnan(criticalSpeed.forward)) && all(isnan(criticalSpeed.backward))
    disp('Keine Schnittpunkte zwischen der ersten Harmonischen mit den Eigenfrequenzen.')
end

disp(' ')

end