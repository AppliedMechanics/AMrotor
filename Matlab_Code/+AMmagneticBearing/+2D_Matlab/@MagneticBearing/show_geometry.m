function show_geometry( self )
%SHOW Summary of this function goes here
%   Detailed explanation goes here

figure()
pdegplot(self.model,'EdgeLabels','off','FaceLabels','on')%,'SubdomainLabels','on')
axis equal

end

