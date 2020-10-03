% Licensed under GPL-3.0-or-later, check attached LICENSE file

function set_forward_plots_damping_ratio( obj )
% Organizes and assembles the plots of the damping ratio over rpm (for Selection 'forward') 
%
%    :return:  Campbell diagram with fwd whirl relative to the damping ratio

figure('Name','Campbell-Diagramm (Forward)','NumberTitle','off');
            axForward = subplot(1,1,1);
            hold on;
            set_plot_labels_damping_ratio(axForward,'Forward')

omega = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_damping_ratio(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end

end

