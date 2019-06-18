
load('Sweep_Time_Anregung.mat')
% Funktion get_vectors_LMS(Dateiname) erstellen
t_start = Signal.x_values.start_value;
t_end = Signal.x_values.increment*(Signal.x_values.number_of_values-1)+Signal.x_values.start_value;
t=t_start:Signal.x_values.increment:t_end;
F = Signal.y_values.values;
figure,plot(t,F)