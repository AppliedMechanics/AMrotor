function show_mesh( self )
% show_mesh ist eine Methode der Klasse MagneticBearing
% Darstellung der Magnetlagervernetzung
% Benoetigte Toolbox: PDE

 figure
    pdemesh(self.model);
        axis equal;
        title('Geometrie und Netz','Interpreter','latex');
        %axis (AxLimits(:) );
        xlabel('x / m','Interpreter','latex');
        ylabel('y / m','Interpreter','latex');

end

