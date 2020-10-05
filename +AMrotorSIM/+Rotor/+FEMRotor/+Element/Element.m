% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Element < handle
% Superclass (abstract) for different element formulations for FEA

% Description of noteworthy properties:
%           I_p % geometrical moment of inertia (polar)
% See also AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement
    properties
        name
        node1
        node2
        material
        localisation_matrix
        area
        volume
        length
        radius_outer
        radius_inner
        mass
        I_p 
        I_y
        mass_matrix
        stiffness_matrix
        gyroscopic_matrix
    end
    
    methods
        
        function self = Element(name,node1,node2, material)
            % Constructor
            
           if nargin == 0
               self.name = 'Empty Element';
           else 
            self.name = name;
            self.node1 = node1;
            self.node2 = node2;
            self.material = material;
           end

        end
        
        function num = set_dof_number(obj,direction)
            % Assigns numbers to formulated (char) directions
            %
            %    :parameter direction: Directions ('u_x','u_y','u_z','psi_x','psi_y','psi_z')
            %    :type direction: char
            %    :return: Corresponding number (num('u_y')=2, or num('psi_x')=4)
            
            dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
            dof_loc = [1,2,3,4,5,6];
            ldof = containers.Map(dof_name,dof_loc);
            
            if strcmpi(direction,'all')
                num = 1:6;
                return
            end
            
            if iscell(direction)
                for i=1:length(direction)
                    if ischar(direction{i})
                        num(i) = ldof(direction{i});
                    elseif length(direction{i}) == 1
                        num(i) = direction{i};
                    end
                end
                
            elseif ischar(direction)
                num = ldof(direction);
            else
                num = direction;
            end
        end
        
        
    end
    
    methods(Abstract)
        
        create_ele_loc_matrix(self,fe_model)
        
        calculate_geometry_parameters(self,fe_model)
        
        assemble_mass_matrix(self)
        
        assemble_stiffness_matrix(self)
        
        assemble_gyroscopic_matrix(self)
        
        
    end
end
