function calculate_geometry_parameters(self,method)
    switch method
        case 'mean'
            self.area = pi*(((self.node1.radius_outer+self.node2.radius_outer)/2)^2 ...
            -((self.node1.radius_inner+self.node2.radius_inner)/2)^2); % m^2
            self.radius_outer = (self.node1.radius_outer+self.node2.radius_outer)/2;
            self.radius_inner = (self.node1.radius_inner+self.node2.radius_inner)/2;
        case 'upper sum'
            if self.node1.radius_outer <= self.node2.radius_outer
               self.area = pi*((self.node2.radius_outer)^2-(self.node2.radius_inner)^2);
               self.radius_outer = self.node2.radius_outer;
               self.radius_inner = self.node2.radius_inner;
            else
               self.area = pi*((self.node1.radius_outer)^2-(self.node1.radius_outer)^2);
               self.radius_outer = self.node1.radius_outer;
               self.radius_inner = self.node1.radius_inner;
            end
        case 'lower sum'
            if self.node1.radius_outer <= self.node2.radius_outer
               self.area = pi*((self.node1.radius_outer)^2-(self.node1.radius_outer)^2);
               self.radius_outer = self.node1.radius_outer;
               self.radius_inner = self.node1.radius_inner;
            else
               self.area = pi*((self.node2.radius_outer)^2-(self.node2.radius_inner)^2);
               self.radius_outer = self.node2.radius_outer;
               self.radius_inner = self.node2.radius_inner;
            end   
    end
    self.length = (self.node2.z-self.node1.z); % m;
    self.volume = self.area*self.length; % m^3
    self.I_p = 0.5*pi*(self.radius_outer^4-self.radius_inner^4);
    self.I_y = pi*(self.radius_outer^4-self.radius_inner^4)/4;

end