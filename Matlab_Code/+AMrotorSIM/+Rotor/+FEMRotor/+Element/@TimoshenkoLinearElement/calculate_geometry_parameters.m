function calculate_geometry_parameters(self,method)
% Anpassungen fuer Darstellung Hohlwelle
    switch method
        case 'mean'
            self.area = pi*(((self.node1.radius+self.node2.radius)/2)^2 ...
            -((self.node1.radius_innen+self.node2.radius_innen)/2)^2); % m^2
            self.radius = (self.node1.radius+self.node2.radius)/2;
            self.radius_innen = (self.node1.radius_innen+self.node2.radius_innen)/2;
        case 'upper sum'
            if self.node1.radius <= self.node2.radius
               self.area = pi*((self.node2.radius)^2-(self.node2.radius_innen)^2);
               self.radius = self.node2.radius;
               self.radius_innen = self.node2.radius_innen;
            else
               self.area = pi*((self.node1.radius)^2-(self.node1.radius)^2);
               self.radius = self.node1.radius;
               self.radius_innen = self.node1.radius_innen;
            end
        case 'lower sum'
            if self.node1.radius <= self.node2.radius
               self.area = pi*((self.node1.radius)^2-(self.node1.radius)^2);
               self.radius = self.node1.radius;
               self.radius_innen = self.node1.radius_innen;
            else
               self.area = pi*((self.node2.radius)^2-(self.node2.radius_innen)^2);
               self.radius = self.node2.radius;
               self.radius_innen = self.node2.radius_innen;
            end   
    end
    self.length = (self.node2.z-self.node1.z); % m;
    self.volume = self.area*self.length; % m^3
    self.I_p = 0.5*pi*(self.radius^4-self.radius_innen^4);
    self.I_y = pi*(self.radius^4-self.radius_innen^4)/4;

end