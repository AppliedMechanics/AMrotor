% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef MeshNode < handle
% Class of the nodes for the finite element mesh
    properties
        name 
        radius_outer
        radius_inner = 0
        z 
    end
    
    methods
        function self = MeshNode(name, z, r, ri)
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
            %    :return: MeshNode object
            
          if nargin == 0
            self.name = 'Default';
          else  
            self.name = name;
            self.z = z;
            self.radius_outer = r;
            self.radius_inner = ri; %Hohlwelle
          end
        end
    end
end