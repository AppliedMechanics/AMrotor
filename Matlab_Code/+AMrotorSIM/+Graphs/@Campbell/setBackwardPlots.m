function setBackwardPlots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (Backward)','NumberTitle','off');
            axForward = subplot(1,1,1);
            hold on;
            setPlotLabels(axForward,'Backward')

omega = obj.experimentCampbell.getOmega()*30/pi;
num = obj.experimentCampbell.getNumberOfEigenValues();
EW = obj.experimentCampbell.getEigenValues();

for b = 1:num.backward
    plotOmegas(axForward,omega,EW.forward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end
end

