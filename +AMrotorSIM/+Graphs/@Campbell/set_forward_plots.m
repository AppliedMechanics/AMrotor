function set_forward_plots( obj )
% Organizes and assembles the plots of omega over rpm (for Selection 'forward') 
%
%    :return:  Campbell diagram with fwd whirl relative to omega

% Licensed under GPL-3.0-or-later, check attached LICENSE file

figure('Name','Campbell-Diagramm (Forward)','NumberTitle','off');
            axForward = subplot(1,1,1);
            hold on;
            set_plot_labels(axForward,'Forward')

rpm = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_omegas(axForward,rpm,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end
plot_harmonic( axForward,rpm )

pause(0.1) % somehow needed for setting limits
lim.forward = max(max(imag(EW.forward)));
ylim(axForward,[0 1.05*lim.forward/2/pi]);

end

