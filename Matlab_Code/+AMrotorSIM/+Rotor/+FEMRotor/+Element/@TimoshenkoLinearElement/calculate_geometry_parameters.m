function calculate_geometry_parameters(self,mesh)

    switch mesh.approximation
        case 'mean'
            self.area = 2*pi*((self.node1.radius+self.node2.radius)/2)^2; % m^2
            self.radius = (self.node1.radius+self.node2.radius)/2;
        case 'upper sum'
            if self.node1.radius <= self.node2.radius
               self.area = 2*pi*(self.node2.radius)^2;
               self.radius = self.node2.radius;
            else
               self.area = 2*pi*(self.node1.radius)^2;
               self.radius = self.node1.radius;
            end
        case 'lower sum'
            if self.node1.radius <= self.node2.radius
               self.area = 2*pi*(self.node1.radius)^2;
               self.radius = self.node1.radius;
            else
               self.area = 2*pi*(self.node2.radius)^2;
               self.radius = self.node2.radius;
            end   
    end
    self.length = (self.node2.z-self.node1.z)*10e-3; % m;
    self.volume = self.area*self.length; % m^3
   % self.mass = self.volume * self.material.density; %kg
    self.I_p = 0.5*pi*self.node1.radius^4;
    self.I_y = (pi*self.node1.radius^4)/4;

end