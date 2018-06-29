classdef MeshNode < handle
   
    properties
        name 
        radius
        z 
    end
    
    methods
        function self = MeshNode(name, z, r)
          if nargin == 0
            self.name = 'Depp';
          else  
            self.name = name;
            self.z = z;
            self.radius = r;
          end
        end
    end
end