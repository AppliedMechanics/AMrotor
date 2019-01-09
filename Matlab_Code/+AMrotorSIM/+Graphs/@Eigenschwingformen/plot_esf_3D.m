function plot_esf_3D(obj,number_esf, param)

n_ew=obj.modalsystem.n_ew;
ColorHandler = AMrotorTools.PlotColors();
ColorHandler.set_up(n_ew);

% plotten der Moden
figure('Name',sprintf('Eigenschwingform %i',number_esf),'NumberTitle','off');
figurehandle = axes;
title(sprintf('Eigenmode Lateral %1.2f Hz, r=sqrt(x^2+y^2)',obj.modalsystem.eigenValues.lateral(number_esf)/(2*pi)))
hold on;

x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
r = sqrt(obj.modalsystem.eigenVectors.lateral_x(:,number_esf).^2 + obj.modalsystem.eigenVectors.lateral_y(:,number_esf).^2);
plotMode3D(figurehandle,x,r,...
    obj.modalsystem.eigenValues.lateral(number_esf),...
    ColorHandler.getColor(number_esf), param)

%legend('show')
grid('on')

end