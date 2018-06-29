classdef FeModel < handle
    
    properties
        mesh
        name
        geometry
        matrices
    end
    
    methods
        function self = FeModel(a)
            if nargin == 0
                self.name = 'Non existent FE-Model';
            else
            self.mesh = a;
            self.name = self.mesh.name;
            end
        end
        
    end
end

