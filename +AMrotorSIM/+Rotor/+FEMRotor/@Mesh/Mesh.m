classdef Mesh < handle
% Mesh  Class of the mesh, which includes the nodes and elements
    properties
        name
        d_min
        d_max
        n_refinement
        approximation
        nodes@AMrotorSIM.Rotor.FEMRotor.MeshNode vector
        elements@AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement vector
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
                self.n_refinement = optn.n_refinement;
                self.approximation = optn.approx;
            end
        end
    end
end