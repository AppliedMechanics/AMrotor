function set_all_plots_deltas( obj )

figure('Name','Campbell-Diagramm (All)','NumberTitle','off');
            axAll = subplot(2,2,[1,3]);
            hold on;
            set_plot_labels_deltas(axAll,'All');
            axForward = subplot(2,2,2);
            hold on;
            set_plot_labels_deltas(axForward,'Forward')
            axBackward = subplot(2,2,4);
            hold on;
            set_plot_labels_deltas(axBackward,'Backward')

omega = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_deltas(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
    plot_deltas(axAll,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end
for b = 1:num.backward
    plot_deltas(axBackward,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
    plot_deltas(axAll,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end

end

