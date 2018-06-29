classdef TimoshenkoLinearElement < Element.Element
    
    properties
    end
    
    methods
        function self = TimoshenkoLinearElement(name,node1,node2,material)
          if nargin == 0
            name = 'No Proper Element';
            node1 = MeshNode();
            node2 = MeshNode();
            material = Material()';
          end
          
          self = self@Element.Element(name,node1,node2,material);
          

        end
        
        function create_ele_loc_matrix(self,fe_model)

        %Vektorversion der Localisierungsmatrix:
        Lv0_ele = [3,9,6,12,1,5,7,11,2,4,8,10];
        
        %Matrixversion:
        L_ele = sparse(12,12); 
        for k = 1:12
            L_ele(k,Lv0_ele(k)) = 1;
        end
            
        self.localisation_matrix = L_ele;           
        end
        
        function calculate_geometry_parameters(self,fe_model)
            self.material = fe_model.geometry.material;
            
            switch fe_model.mesh.approximation
                case 'mean'
                    self.area = 2*pi*((self.node1.radius+self.node2.radius)/2)^2; % m^2
                    self.radius = (self.node1.radius+self.node2.radius)/2;
                case 'upper sum'
                    if self.node1.radius <= self.node2.radius
                       self.area = 2*pi*(self.node2.radius)^2;
                       self.radius = self.node2.radius;
                    else
                       self.area = 2*pi*(self.node1.radius)^2;
                       self.radius = self.node1.radius;
                    end
                case 'lower sum'
                    if self.node1.radius <= self.node2.radius
                       self.area = 2*pi*(self.node1.radius)^2;
                       self.radius = self.node1.radius;
                    else
                       self.area = 2*pi*(self.node2.radius)^2;
                       self.radius = self.node2.radius;
                    end   
            end
            self.length = (self.node2.z-self.node1.z)*10e-3; % m;
            self.volume = self.area*self.length; % m^3
            self.mass = self.volume * self.material.density; %kg
            self.I_p = 0.5*pi*self.node1.radius^4;
            self.I_y = (pi*self.node1.radius^4)/4;
            
        end
        
        function [M] = assemble_mass_matrix(self)
            
            M_A = compute_axial_mass_matrix(self);
            M_T = compute_tangential_mass_matrix(self);
            [M_F1, M_F2] = compute_consistent_mass_matrix(self);
            
            
            M = zeros(12,12);
            
            M(1:2,1:2) = M_A;
            M(3:4,3:4) = M_T;
            M(5:8,5:8) = M_F1;
            M(9:12,9:12) = M_F2;
            
            self.mass_matrix = M;
        end
        
        function [K] = assemble_stiffness_matrix(self)
            
            K_A = compute_axial_stiffness_matrix(self);
            K_T = compute_tangent_stiffness_matrix(self);
            [K_F1, K_F2] = compute_bending_stiffness_matrix(self);
            
            K = zeros(12,12);
            
            K(1:2,1:2) = K_A;
            K(3:4,3:4) = K_T;
            K(5:8,5:8) = K_F1;
            K(9:12,9:12) = K_F2;
            
            self.stiffness_matrix = K;
        end
       
        function [G] = assemble_gyroscopic_matrix(self)
            G = sparse(12,12);
            G_ele = compute_gyroscopic_matrix(self);
            
            G(5:12,5:12) = G_ele;
            
            self.gyroscopic_matrix = G;
        end
            
    end
    
end