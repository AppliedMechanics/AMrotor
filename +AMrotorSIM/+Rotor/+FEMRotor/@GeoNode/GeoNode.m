classdef GeoNode < handle
% Class of the geometric nodes which are used to build the discretisation

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
        name 
        x; % outer radius   
        xi; % inner radius 
        z; % axial position on the rotor  
    end
    
    methods
        function self = GeoNode(name, z, x, xi)
            % Constructor
            %
            %    :parameter name: Name
            %    :type name: char
            %    :parameter z: Axial position on the rotor
            %    :type z: double
            %    :parameter x: Outer radius
            %    :type x: double
            %    :parameter xi: Inner radius
            %    :type xi: double
            %    :return: GeoNode object
            
            self.name = name;
            self.z = z;
            self.x = x;
            self.xi = xi;
        end
    end
end
        