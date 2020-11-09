function [ZeroCrossingForward, ZeroCrossingBackward] = print_damping_zero_crossing(obj)
% Prints the zero crossings of damping, which indicates instability
%
%    :return: Display of the zero crossings of damping in the Command Window

% Licensed under GPL-3.0-or-later, check attached LICENSE file

omega = obj.experimentCampbell.get_omega();
EW = obj.experimentCampbell.get_eigenvalues();

ZeroCrossingForward = [];
ZeroCrossingBackward = [];

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
i=1;
for s=1:n_moden
    if ~isnan(zeroCrossings.forward(s)) %remove NaN values
        ZeroCrossingForward.rpm(i) = zeroCrossings.forward(s)*60/2/pi;
        ZeroCrossingForward.modeNumber(i) = s;
        disp([num2str(ZeroCrossingForward.modeNumber(i)),'. Mode (forward): bei ', num2str(ZeroCrossingForward.rpm(i)), ' 1/min'])
        i=i+1;
    end
end
% disp(' ')

if ~all(isnan(zeroCrossings.backward))
    disp('Moden mit backward-whirl')
end
n_moden=length(zeroCrossings.backward);
i=1;
for s=1:n_moden
    if ~isnan(zeroCrossings.backward(s))
        ZeroCrossingBackward.rpm(i) = zeroCrossings.backward(s)*60/2/pi;
        ZeroCrossingBackward.modeNumber(i) = s;
        disp([num2str(ZeroCrossingBackward.modeNumber(i)),'. Mode (backward): bei ', num2str(ZeroCrossingBackward.rpm(i)), ' 1/min'])
        i=i+1;
    end
end

if all(isnan(zeroCrossings.forward)) && all(isnan(zeroCrossings.backward))
    disp('Kein Nulldurchgang der Dämpfung im betrachteten Bereich.')
end

disp(' ')

end