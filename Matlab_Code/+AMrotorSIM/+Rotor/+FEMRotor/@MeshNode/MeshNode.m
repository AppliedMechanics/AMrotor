classdef MeshNode < handle
   
    properties
        name 
        radius
        radius_innen = 0
        z 
    end
    
    methods
        function self = MeshNode(name, z, r, ri)
          if nargin == 0
            self.name = 'Depp';
          else  
            self.name = name;
            self.z = z;
            self.radius = r;
            self.radius_innen = ri; %Hohlwelle
          end
        end
    end
end