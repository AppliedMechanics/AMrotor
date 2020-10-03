% Licensed under GPL-3.0-or-later, check attached LICENSE file

function set_all_plots_damping_ratio( obj )
% Organizes and assembles the plots of the damping ratio over rpm (for Selection 'all') 
%
%    :return:  Campbell diagram with fwd and bwd whirl relative to the damping ratio

figure('Name','Campbell-Diagramm (All)','NumberTitle','off');
            axAll = subplot(2,2,[1,3]);
            hold on;
            set_plot_labels_damping_ratio(axAll,'All');
            axForward = subplot(2,2,2);
            hold on;
            set_plot_labels_damping_ratio(axForward,'Forward')
            axBackward = subplot(2,2,4);
            hold on;
            set_plot_labels_damping_ratio(axBackward,'Backward')

omega = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_damping_ratio(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
    plot_damping_ratio(axAll,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end
for b = 1:num.backward
    plot_damping_ratio(axBackward,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
    plot_damping_ratio(axAll,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end

end

