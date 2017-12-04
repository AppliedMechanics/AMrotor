function setForwardPlots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (Forward)','NumberTitle','off');
            axForward = subplot(1,1,1);
            hold on;
            setPlotLabels(axForward,'Forward')

omega = obj.experimentCampbell.getOmega()*30/pi;
num = obj.experimentCampbell.getNumberOfEigenValues();
EW = obj.experimentCampbell.getEigenValues();

for f = 1:num.forward
    plotOmegas(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end

pause(0.1) % somehow needed for setting limits
lim.forward = max(max(imag(EW.forward)));
ylim(axForward,[0 1.05*lim.forward/2/pi]);

end

