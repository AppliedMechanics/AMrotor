% Licensed under GPL-3.0-or-later, check attached LICENSE file

function get_EW(obj)
% Prints the zero crossing of the damping ratio as stability limit
%
%    :return: Display of the zero crossing in the Command Window

omega = obj.experimentCampbell.get_omega();
EW = obj.experimentCampbell.get_eigenvalues();

for i = 1:size(EW.forward,1)
    zeroCrossings.forward(i) = obj.get_zero_crossing(omega,-real(EW.forward(i,:)));
end
for i = 1:size(EW.backward,1)
    zeroCrossings.backward(i) = obj.get_zero_crossing(omega,-real(EW.backward(i,:)));
end

disp('Nulldurchgang der Dämpfung')
if ~all(isnan(zeroCrossings.forward))
    disp('Moden mit forward-whirl')
end
n_moden=length(zeroCrossings.forward);
for s=1:n_moden
    if ~isnan(zeroCrossings.forward(s)) %remove NaN values
        disp([num2str(s),'. Mode (forward): bei ', num2str(zeroCrossings.forward(s)*60/2/pi), ' 1/min'])
    end
end
% disp(' ')

if ~all(isnan(zeroCrossings.backward))
    disp('Moden mit backward-whirl')
end
n_moden=length(zeroCrossings.backward);
for s=1:n_moden
    if ~isnan(zeroCrossings.backward(s))
        disp([num2str(s),'. Mode (backward): bei ', num2str(zeroCrossings.backward(s)*60/2/pi), ' 1/min'])
    end
end

if all(isnan(zeroCrossings.forward)) && all(isnan(zeroCrossings.backward))
    disp('Kein Nulldurchgang der Dämpfung im betrachteten Bereich.')
end

disp(' ')

end