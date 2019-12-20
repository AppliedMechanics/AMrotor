classdef Element < handle
% Element Superclass for different element formulations for the fea
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
        I_p % geometrical moment of inertia (polar)
        I_y
        mass_matrix
        stiffness_matrix
        gyroscopic_matrix
    end
    
    methods
        
        function self = Element(name,node1,node2, material)
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
