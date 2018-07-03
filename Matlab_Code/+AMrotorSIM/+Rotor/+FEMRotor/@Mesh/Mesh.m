classdef Mesh < handle
    
    properties
        name
        d_min
        d_max
        approximation
        nodes = AMrotorSIM.Rotor.FEMRotor.MeshNode().empty
        elements = AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement().empty
    end
    
    methods
        
        function self = Mesh(optn)
            if nargin == 0
                self.name = 'Empty Mesh';
                disp('No Options for Meshing...!');
            else
                self.name = optn.name;
                self.d_min = optn.d_min;
                self.d_max = optn.d_max;
                self.approximation = optn.approx;
            end
        end
    end
end