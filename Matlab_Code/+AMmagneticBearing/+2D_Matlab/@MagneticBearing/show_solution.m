function [ output_args ] = show_solution( self,solution )
% show_solution ist eine Methode der Klasse MagneticBearing
% Darstellung des Magnetischen Vektorpotentials im Magnetlager
A=solution.NodalSolution;
figure
pdegplot(self.model,'EdgeLabels','off','FaceLabels','off');    % Plotten der Geometrie mit Fasen-Beschriftung
hold on
pdeplot(self.model,'Mesh','off','FaceAlpha',0.1,'Contour','on','ColorMap','parula','XYData',A)
title ('Magnetisches Vektorpotential','Interpreter','latex');
axis equal;
xlabel('x / m','Interpreter','latex');
ylabel('y / m','Interpreter','latex');
hold off;    
end
