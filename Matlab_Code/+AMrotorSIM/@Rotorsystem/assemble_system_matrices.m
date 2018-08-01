function assemble_system_matrices(self)
    
%% Rotormatrizen aus FEM erstellen
            self.rotor.assemble_fem
            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Einträge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

%% Lagermatrizen aufaddieren

            M_bearing=sparse(6*n_nodes,6*n_nodes);
            K_bearing=sparse(6*n_nodes,6*n_nodes);
            G_bearing=sparse(6*n_nodes,6*n_nodes);
            
            i=0;
            for bearing = self.bearings
                
                bearing.create_ele_loc_matrix
                bearing.get_loc_damping_matrix
                bearing.get_loc_mass_matrix
                bearing.get_loc_stiffness_matrix
                
                i=i+1;
                bearing_node = self.rotor.find_node_nr(bearing.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;

                M_bearing = M_bearing+L_ele'*bearing.mass_matrix*L_ele;
                K_bearing = K_bearing+L_ele'*bearing.stiffness_matrix*L_ele;
                G_bearing = G_bearing+L_ele'*bearing.damping_matrix*L_ele;
            end
        
%% Gesamtmatrizen addieren
        self.systemmatrices.M = self.rotor.matrices.M + M_bearing;
        self.systemmatrices.K = self.rotor.matrices.K + K_bearing;
        self.systemmatrices.G = self.rotor.matrices.G + G_bearing;
        
      
end