function calculate_geometry_parameters(self,method)
    switch method
        case 'symmetric'
            %detect jump for outer radius
            if self.node2.radius_outer > self.node1.radius_outer
                % ascending jump
                self.radius_outer = self.node1.radius_outer;
            else
                %descending jump or no jump
                self.radius_outer = self.node2.radius_outer;
            end
            %detect jump for inner radius
            if self.node2.radius_inner > self.node1.radius_inner
                % ascending jump
                self.radius_inner = self.node1.radius_inner;
            else
                %descending jump or no jump
                self.radius_inner = self.node2.radius_inner;
            end
        case 'mean'
            self.radius_outer = (self.node1.radius_outer+self.node2.radius_outer)/2;
            self.radius_inner = (self.node1.radius_inner+self.node2.radius_inner)/2;
            
        case 'upper sum'
            if self.node1.radius_outer <= self.node2.radius_outer
               self.radius_outer = self.node2.radius_outer;
               self.radius_inner = self.node2.radius_inner;
            else
               self.radius_outer = self.node1.radius_outer;
               self.radius_inner = self.node1.radius_inner;
            end
        case 'lower sum'
            if self.node1.radius_outer <= self.node2.radius_outer
               self.radius_outer = self.node1.radius_outer;
               self.radius_inner = self.node1.radius_inner;
            else
               self.radius_outer = self.node2.radius_outer;
               self.radius_inner = self.node2.radius_inner;
            end   
    end
    self.area = pi*(self.radius_outer^2 - self.radius_inner^2); % m^2
    self.length = (self.node2.z-self.node1.z); % m;
    self.volume = self.area*self.length; % m^3
    self.I_p = 0.5*pi*(self.radius_outer^4-self.radius_inner^4);
    self.I_y = pi*(self.radius_outer^4-self.radius_inner^4)/4;

end