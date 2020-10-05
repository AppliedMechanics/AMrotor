% Licensed under GPL-3.0-or-later, check attached LICENSE file

function calculate_geometry_parameters(self,method)
% Processes how jumps in the geometry (which radius for the element) should be discretized
%
%    :parameter method: Check function: 'symmetric','mean','upper sum','lower sum'
%    :type method: char
%    :return: Depending variables like volume, moment of inertia,...

%     symmetric, takes for the element radius (inner and outer) for an ascending radius jump between the nodes the radius of node 1 and for a descending radius jump (or no jump) the radius of node 2 (for inner and outer radius)
%     mean, takes for the element radius (inner and outer) the particular mean radius $r_{element}=(r_{node1}+r_{node2})/2$ (inner and outer)
%     lower sum, takes the lower radius (inner and outer) of node 1 or node 2 for the element radius (inner and outer)
%     upper sum, takes the upper radius (inner and outer) of node 1 or node 2 for the element radius (inner and outer)

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