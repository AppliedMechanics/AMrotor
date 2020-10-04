% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_esf_3D(obj,number_esf, param)
% Organizes/prepares the 3D plots of the mode shapes
%
%    :param number_esf: Number of the mode shape
%    :type number_esf: double
%    :param param: Additional parameters for visualization (scale of EV, ...)
%    :type param: struct
%    :return: Figure with 3D visualisation of the desired mode shape

n_ew=obj.modalsystem.n_ew;
ColorHandler = AMrotorTools.PlotColors();
ColorHandler.set_up(n_ew);

% plotten der Moden
figure('Name',sprintf('Eigenschwingform %i',number_esf),'NumberTitle','off');
figurehandle = axes;
title(sprintf('Eigenmode Lateral %1.2f Hz',imag(obj.modalsystem.eigenValues.lateral(number_esf))/(2*pi)))
hold on;

x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];

plotMode3D(figurehandle,x,obj.modalsystem.eigenVectors.lateral_x(:,number_esf),...
    obj.modalsystem.eigenVectors.lateral_y(:,number_esf),...
    imag(obj.modalsystem.eigenValues.lateral(number_esf)),...
    ColorHandler.getColor(number_esf), param)

%legend('show')
grid('on')

end