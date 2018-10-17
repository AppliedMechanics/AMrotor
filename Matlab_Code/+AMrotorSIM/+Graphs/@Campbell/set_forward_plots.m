function set_forward_plots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (Forward)','NumberTitle','off');
            axForward = subplot(1,1,1);
            hold on;
            set_plot_labels(axForward,'Forward')

omega = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_omegas(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end

pause(0.1) % somehow needed for setting limits
lim.forward = max(max(imag(EW.forward)));
ylim(axForward,[0 1.05*lim.forward/2/pi]);

end

