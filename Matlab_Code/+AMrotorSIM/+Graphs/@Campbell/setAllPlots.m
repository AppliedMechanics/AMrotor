function setAllPlots( obj )
%GETALLPLOTS Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Campbell-Diagramm (All)','NumberTitle','off');
            axAll = subplot(2,2,[1,3]);
            hold on;
            setPlotLabels(axAll,'All');
            axForward = subplot(2,2,2);
            hold on;
            setPlotLabels(axForward,'Forward')
            axBackward = subplot(2,2,4);
            hold on;
            setPlotLabels(axBackward,'Backward')

omega = obj.experimentCampbell.getOmega()*30/pi;
num = obj.experimentCampbell.getNumberOfEigenValues();
EW = obj.experimentCampbell.getEigenValues();

for f = 1:num.forward
    plotOmegas(axForward,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
    plotOmegas(axAll,omega,EW.forward(f,:),...
               obj.ColorHandler.getColor(f))
end
for b = 1:num.backward
    plotOmegas(axBackward,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
    plotOmegas(axAll,omega,EW.backward(b,:),...
               obj.ColorHandler.getColor(b+num.forward))
end

end

