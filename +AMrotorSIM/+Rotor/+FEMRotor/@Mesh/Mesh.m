classdef Mesh < handle
% Mesh  Class of the mesh, which includes the nodes and elements
    properties
        name
        d_min               % minimum allowed element length
        d_max               % maximum allowed element length
        n_refinement        % no of refinement steps, when looking for the optimal element length
        
        % Methods for linear approximation of the element properties
        % allowed: upper sum, lower sum, mean, symmetric
        approximation      
        
        % See also AMrotorSIM.Rotor.FEMRotor.MeshNode
        nodes (1,:) AMrotorSIM.Rotor.FEMRotor.MeshNode
        
        % See also AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement
        elements (1,:) AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement
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