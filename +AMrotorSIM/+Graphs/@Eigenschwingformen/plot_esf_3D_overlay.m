% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_esf_3D_overlay(obj, number_esf, param)
% Organizes/prepares the 3D plots of the mode shapes with overlayed original rotor
%
%    :param number_esf: Number of the mode shape
%    :type number_esf: double
%    :param param: Additional parameters for visualization (scale of EV, ...)
%    :type param: struct
%    :return: Figure with 3D visualisation of the desired mode shape with overlayed original rotor

n_ew=obj.modalsystem.n_ew;
ColorHandler = AMrotorTools.PlotColors();
ColorHandler.set_up(n_ew);

% plotten des Rotorsystems
import AMrotorSIM.*
g=Graphs.Visu_Rotorsystem(obj.modalsystem.rotorsystem);
figurehandle = g.show();

x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
V_x = obj.modalsystem.eigenVectors.lateral_x(:,number_esf);
V_y = obj.modalsystem.eigenVectors.lateral_y(:,number_esf);
scaleFactor = 1/max(abs([V_x;V_y]))*1e-1;%mean([V_x;V_y]);%
V_x = V_x*scaleFactor;
V_y = V_y*scaleFactor;

% plotten der Moden
% set(figurehandle,'Name',sprintf('Eigenschwingform %i',number_esf),'NumberTitle','off');
% ax = axes;
title(figurehandle,sprintf('Eigenmode Lateral %1.2f Hz, scaleFactor %.2d',imag(obj.modalsystem.eigenValues.lateral(number_esf))/(2*pi),scaleFactor))
hold on;

plotMode3D(figurehandle,x,V_x, V_y,...
    imag(obj.modalsystem.eigenValues.lateral(number_esf)),...
    ColorHandler.getColor(number_esf), param)

%legend('show')
grid('on')
drawnow
end