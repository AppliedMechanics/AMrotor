function set_backward_plots_damping_ratio( obj )

figure('Name','Campbell-Diagramm (Backward)','NumberTitle','off');
            axBackward = subplot(1,1,1);
            hold on;
            set_plot_labels_damping_ratio(axBackward,'Backward')

omega = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for b = 1:num.backward
    plot_damping_ratio(axBackward,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end

end

