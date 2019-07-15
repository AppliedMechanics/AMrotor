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
        nodes@AMrotorSIM.Rotor.FEMRotor.MeshNode vector
        
        % See also AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement
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