function print_damping_zero_crossing(obj)

obj.experimentCampbell.get_omega()
zeroCrossings = obj.experimentCampbell.read_zero_crossing();

disp('Nulldurchgang der Dämpfung')
disp('Moden mit forward-whirl')
n_moden=length(zeroCrossings.forward);
for s=1:n_moden
    disp([num2str(s),'. Mode (forward): bei ', num2str(zeroCrossings.forward(s)*60/2/pi), ' 1/min'])
end
disp(' ')

disp('Moden mit backward-whirl')
n_moden=length(zeroCrossings.backward);
for s=1:n_moden
    disp([num2str(s),'. Mode (backward): bei ', num2str(zeroCrossings.backward(s)*60/2/pi), ' 1/min'])
end
disp(' ')

end