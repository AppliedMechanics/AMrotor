function [M,C,G,K]= assemble_system_matrices(self,rpm,varargin)

         if nargin == 1
             rpm=0;
         elseif nargin==3
             Z=varargin{1};
         end

%% Rotormatrizen aus FEM erstellen
           
            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Einträge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.


%% Add disc matrices

            M_disc=sparse(6*n_nodes,6*n_nodes);
            K_disc=sparse(6*n_nodes,6*n_nodes);
            G_disc=sparse(6*n_nodes,6*n_nodes);
            
            
            for disc = self.discs
                
                disc.create_ele_loc_matrix;
                disc.get_loc_gyroscopic_matrix;
                disc.get_loc_mass_matrix;
                disc.get_loc_stiffness_matrix;
                
                disc_node = self.rotor.find_node_nr(disc.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(disc_node-1)*6+1:(disc_node-1)*6+6)=disc.localisation_matrix;

                M_disc = M_disc+L_ele'*disc.mass_matrix*L_ele;
                K_disc = K_disc+L_ele'*disc.stiffness_matrix*L_ele;
                G_disc = G_disc+L_ele'*disc.gyroscopic_matrix*L_ele;
            end
            
            
%% Add component matrices

            M_Comp =sparse(6*n_nodes,6*n_nodes);
            D_Comp =sparse(6*n_nodes,6*n_nodes);
            G_Comp =sparse(6*n_nodes,6*n_nodes);
            K_Comp =sparse(6*n_nodes,6*n_nodes);
                 
            for Component = self.components 
                Component.create_ele_loc_matrix;
                Component.get_loc_mass_matrix(rpm);
                Component.get_loc_damping_matrix(rpm);
                Component.get_loc_gyroscopic_matrix(rpm);
                Component.get_loc_stiffness_matrix(rpm);

                component_node = self.rotor.find_node_nr(Component.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(component_node-1)*6+1:(component_node-1)*6+6)=Component.localisation_matrix;

                M_Comp  = M_Comp +L_ele'*Component.mass_matrix*L_ele;
                D_Comp  = D_Comp +L_ele'*Component.damping_matrix*L_ele; 
                G_Comp  = G_Comp +L_ele'*Component.gyroscopic_matrix*L_ele; 
                K_Comp  = K_Comp +L_ele'*Component.stiffness_matrix*L_ele;
            end            
        
%% Add to global matrices
        M = self.rotor.matrices.M + M_disc + M_Comp;
        C = self.rotor.matrices.D + D_Comp ;
        G = self.rotor.matrices.G + G_disc + G_Comp;
        K = self.rotor.matrices.K + K_disc + K_Comp ;

        
      
end