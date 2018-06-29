classdef Mesh < handle
    
    properties
        name
        d_min
        d_max
        approximation
        nodes = MeshNode().empty
        elements = Element.TimoshenkoLinearElement().empty
    end
    
    methods
        
        function self = Mesh(optn)
            if nargin == 0
                self.name = 'No Mesh';
            else
                self.name = optn.name;
                self.d_min = optn.d_min;
                self.d_max = optn.d_max;
                self.approximation = optn.approx;
            end
        end
    end
end