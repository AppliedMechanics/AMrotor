classdef GeoNode < handle
    properties
        name 
        x 
        z 
    end
    
    methods
        function self = GeoNode(name, z, x)
            self.name = name;
            self.z = z;
            self.x = x;
        end
    end
end
        