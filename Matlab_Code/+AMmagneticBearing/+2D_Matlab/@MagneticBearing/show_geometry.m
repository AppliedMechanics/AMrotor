function show_geometry( self )
% show_geometry ist eine Methode der Klasse MagneticBearing
% Darstellung der Magnetlagergeometrie
% Benoetigte Toolbox: PDE

figure()
pdegplot(self.model,'EdgeLabels','off','FaceLabels','on')%,'SubdomainLabels','on')
axis equal

end

