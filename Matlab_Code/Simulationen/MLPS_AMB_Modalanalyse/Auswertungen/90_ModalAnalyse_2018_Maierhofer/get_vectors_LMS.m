function [t,Y] = get_vectors_LMS(Signal)
% extract the time and measured values from the Signal generated from the
% Siemens LMS-System
t_start = Signal.x_values.start_value;
t_end = Signal.x_values.increment*(Signal.x_values.number_of_values-1)+Signal.x_values.start_value;
t=(t_start:Signal.x_values.increment:t_end)';
Y = Signal.y_values.values;
end