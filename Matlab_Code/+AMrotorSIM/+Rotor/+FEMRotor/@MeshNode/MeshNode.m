classdef MeshNode < handle
   
    properties
        name 
        radius_outer
        radius_inner = 0
        z 
    end
    
    methods
        function self = MeshNode(name, z, r, ri)
          if nargin == 0
            self.name = 'Depp';
          else  
            self.name = name;
            self.z = z;
            self.radius_outer = r;
            self.radius_inner = ri; %Hohlwelle
          end
        end
    end
end