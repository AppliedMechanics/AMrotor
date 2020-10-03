% Licensed under GPL-3.0-or-later, check attached LICENSE file

function set_all_plots(obj)
% Organizes and assembles the plots of omega over rpm (for Selection 'all') 
%
%    :return:  Campbell diagram with fwd and bwd whirl relative to omega

figure('Name','Campbell-Diagramm (All)','NumberTitle','off');
            axAll = subplot(2,2,[1,3]);
            hold on;
            set_plot_labels(axAll,'All');
            axForward = subplot(2,2,2);
            hold on;
            set_plot_labels(axForward,'Forward')
            axBackward = subplot(2,2,4);
            hold on;
            set_plot_labels(axBackward,'Backward')

rpm = obj.experimentCampbell.get_omega()*30/pi;
num = obj.experimentCampbell.get_number_of_eigenvalues();
EW = obj.experimentCampbell.get_eigenvalues();

for f = 1:num.forward
    plot_omegas(axForward,rpm,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
    plot_omegas(axAll,rpm,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end
for b = 1:num.backward
    plot_omegas(axBackward,rpm,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
    plot_omegas(axAll,rpm,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end
plot_harmonic( axForward,rpm )
plot_harmonic( axBackward,rpm )
plot_harmonic( axAll,rpm )

pause(0.1) % somehow needed for setting limits
lim.forward = max(max(imag(EW.forward)));
lim.backward =max(max(imag(EW.backward)));
ylim(axForward,[0 1.05*lim.forward/2/pi]);
ylim(axBackward,[0 1.05*lim.backward/2/pi]);
ylim(axAll,[0 1.05*max(lim.forward,lim.backward)/2/pi]);
end

