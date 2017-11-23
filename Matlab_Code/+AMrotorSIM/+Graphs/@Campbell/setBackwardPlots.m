function setBackwardPlots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (Backward)','NumberTitle','off');
            axBackward = subplot(1,1,1);
            hold on;
            setPlotLabels(axBackward,'Backward')

omega = obj.experimentCampbell.getOmega()*30/pi;
num = obj.experimentCampbell.getNumberOfEigenValues();
EW = obj.experimentCampbell.getEigenValues();

for b = 1:num.backward
    plotOmegas(axBackward,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end

pause(0.1) % somehow needed for setting limits
lim.backward =max(max(imag(EW.backward)));
ylim(axBackward,[0 1.05*lim.backward/2/pi]);

end

