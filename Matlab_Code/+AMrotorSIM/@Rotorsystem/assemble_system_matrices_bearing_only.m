function [M,C,G,K]= assemble_system_matrices_bearing_only(self,rpm)

         if nargin == 1
             rpm=0;
         end

%% Rotormatrizen aus FEM erstellen
           
            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Eintr�ge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

%% Add bearing matrices

            M_bearing=sparse(6*n_nodes,6*n_nodes);
            K_bearing=sparse(6*n_nodes,6*n_nodes);
            G_bearing=sparse(6*n_nodes,6*n_nodes);
            C_bearing=sparse(6*n_nodes,6*n_nodes);
            
            
            for bearing = self.bearings
                
                bearing.create_ele_loc_matrix;
                bearing.get_loc_gyroscopic_matrix(rpm);
                bearing.get_loc_damping_matrix(rpm);
                bearing.get_loc_mass_matrix(rpm);
                bearing.get_loc_stiffness_matrix(rpm);
                
                bearing_node = self.rotor.find_node_nr(bearing.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;

                M_bearing = M_bearing+L_ele'*bearing.mass_matrix*L_ele;
                K_bearing = K_bearing+L_ele'*bearing.stiffness_matrix*L_ele;
                C_bearing = C_bearing+L_ele'*bearing.damping_matrix*L_ele;
                G_bearing = G_bearing+L_ele'*bearing.gyroscopic_matrix*L_ele;
            end

%% Add to global matrices
        M = self.rotor.matrices.M + M_bearing ;
        C = self.rotor.matrices.D + C_bearing;
        G = self.rotor.matrices.G + G_bearing;
        K = self.rotor.matrices.K + K_bearing;

        
      
end