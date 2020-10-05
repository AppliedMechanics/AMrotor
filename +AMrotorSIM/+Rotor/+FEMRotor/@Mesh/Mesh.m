% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Mesh < handle
% Class of the mesh, which includes the nodes and elements

% Description of noteworthy properties:
%         d_min               % minimum allowed element length
%         d_max               % maximum allowed element length
%         n_refinement        % no of refinement steps, when looking for the optimal element length
%         
%         % Methods for linear approximation of the element properties
%         % allowed: upper sum, lower sum, mean, symmetric
%         approximation  
    properties
        name
        d_min               
        d_max              
        n_refinement        

        approximation      
        nodes (1,:) AMrotorSIM.Rotor.FEMRotor.MeshNode
        elements (1,:) AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement
    end
    
    methods
        
        function self = Mesh(optn)
            
            % Constructor
            %
            %    :parameter optn: Cnfg-rotor substruct of cnfg-struct (cnfg.cnfg_rotor.mesh_opt)
            %    :type optn: struct
            %    :return: Mesh object
            
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