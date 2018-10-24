function assemble_system_matrices(self)
    
% ohne Dichtungsmatrizen, da diese erst vor Zeitintegration mit der
% entsprechenden Drehzahl erstellt werden koennen

%% Rotormatrizen aus FEM erstellen
            self.rotor.assemble_fem
            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Eintr�ge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

%% Add bearing matrices

            M_bearing=sparse(6*n_nodes,6*n_nodes);
            K_bearing=sparse(6*n_nodes,6*n_nodes);
            G_bearing=sparse(6*n_nodes,6*n_nodes);
            
            
            for bearing = self.bearings
                if ~strcmp(bearing.type,'LookUpTableBearing') 
                    %Do not build systemmatrices if bearing is of type 'LookUpTableBearing', i.e. if systemmatrices are rpm-dependent
                bearing.create_ele_loc_matrix;
                bearing.get_loc_gyroscopic_matrix(0);
                bearing.get_loc_damping_matrix(0);
                bearing.get_loc_mass_matrix(0);
                bearing.get_loc_stiffness_matrix(0);
                
                bearing_node = self.rotor.find_node_nr(bearing.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;

                M_bearing = M_bearing+L_ele'*bearing.mass_matrix*L_ele;
                K_bearing = K_bearing+L_ele'*bearing.stiffness_matrix*L_ele;
                G_bearing = G_bearing+L_ele'*bearing.gyroscopic_matrix*L_ele;
                end
            end

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
        
%% Add to global matrices
        self.systemmatrices.M = self.rotor.matrices.M + M_bearing + M_disc;
        self.systemmatrices.K = self.rotor.matrices.K + K_bearing + K_disc;
        self.systemmatrices.G = self.rotor.matrices.G + G_bearing + G_disc;
        self.systemmatrices.D = self.rotor.matrices.D;
        
      
end