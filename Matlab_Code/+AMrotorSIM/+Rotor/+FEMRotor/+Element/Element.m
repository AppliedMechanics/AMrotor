classdef (Abstract) Element < handle
    properties
        name
        node1
        node2
        material
        localisation_matrix
        area
        volume
        length
        radius
        radius_innen
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
    end
    
    methods(Abstract)
        
        create_ele_loc_matrix(self,fe_model)
        
        calculate_geometry_parameters(self,fe_model)
        
        assemble_mass_matrix(self)
        
        assemble_stiffness_matrix(self)
        
        assemble_gyroscopic_matrix(self)
        
        
    end
end
