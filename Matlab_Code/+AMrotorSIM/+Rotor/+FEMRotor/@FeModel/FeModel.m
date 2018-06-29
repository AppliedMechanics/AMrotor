classdef FeModel < handle
    
    properties
        mesh
        name
        geometry
        matrices
    end
    
    methods
        function self = FeModel(name,mesh_opt)
            if nargin == 0
                self.name = 'Non existent FE-Model';
            else
            self.name = name;
            self.mesh = mesh_opt;
            end
        end
        
    end
end

