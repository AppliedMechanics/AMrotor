function plot_esf_3D_overlay(obj, number_esf, param)

n_ew=obj.modalsystem.n_ew;
ColorHandler = AMrotorTools.PlotColors();
ColorHandler.set_up(n_ew);

% plotten des Rotorsystems
import AMrotorSIM.*
g=Graphs.Visu_Rotorsystem(obj.modalsystem.rotorsystem);
figurehandle = g.show();

% plotten der Moden
% set(figurehandle,'Name',sprintf('Eigenschwingform %i',number_esf),'NumberTitle','off');
% ax = axes;
title(figurehandle,sprintf('Eigenmode Lateral %1.2f Hz',obj.modalsystem.eigenValues.lateral(number_esf)/(2*pi)))
hold on;

x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
r = sqrt(obj.modalsystem.eigenVectors.lateral_x(:,number_esf).^2 + obj.modalsystem.eigenVectors.lateral_y(:,number_esf).^2);
plotMode3D(figurehandle,x,r,...
    obj.modalsystem.eigenValues.lateral(number_esf),...
    ColorHandler.getColor(number_esf), param)

%legend('show')
grid('on')
end