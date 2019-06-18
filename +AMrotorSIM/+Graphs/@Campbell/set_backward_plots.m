function set_backward_plots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (Backward)','NumberTitle','off');
            axBackward = subplot(1,1,1);
            hold on;
            set_plot_labels(axBackward,'Backward')

rpm = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for b = 1:num.backward
    plot_omegas(axBackward,rpm,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end
plot_harmonic( axBackward,rpm )

pause(0.1) % somehow needed for setting limits
lim.backward =max(max(imag(EW.backward)));
ylim(axBackward,[0 1.05*lim.backward/2/pi]);

end

