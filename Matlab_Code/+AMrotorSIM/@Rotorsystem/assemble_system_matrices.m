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
            
%% Add seal matrices

            M_seal=sparse(6*n_nodes,6*n_nodes);
            K_seal=sparse(6*n_nodes,6*n_nodes);
            D_seal=sparse(6*n_nodes,6*n_nodes);
                 
            for seal = self.seals 
                seal.create_ele_loc_matrix;
                seal.get_loc_system_matrices(rpm);

                seal_node = self.rotor.find_node_nr(seal.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=seal.localisation_matrix;

                M_seal = M_seal+L_ele'*seal.mass_matrix*L_ele;
                K_seal = K_seal+L_ele'*seal.stiffness_matrix*L_ele;
                D_seal = D_seal+L_ele'*seal.damping_matrix*L_ele;        
            end
        
%% Add nonlinear seal matrices

            for sealNonLinear = self.sealsNonLinear 
                seal_node = self.rotor.find_node_nr(sealNonLinear.position);
                sealNonLinear.create_ele_loc_matrix;
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=sealNonLinear.localisation_matrix;
                
                dof_u_x = self.rotor.get_gdof('u_x',seal_node);
                dof_psi_z = self.rotor.get_gdof('psi_z',seal_node);
                node.q = Z(dof_u_x:dof_psi_z);
                node.qd = Z(6*n_nodes+(dof_u_x:dof_psi_z));
                
                sealNonLinear.get_loc_system_matrices(node);

                M_seal = M_seal+L_ele'*sealNonLinear.mass_matrix*L_ele;
                K_seal = K_seal+L_ele'*sealNonLinear.stiffness_matrix*L_ele;
                D_seal = D_seal+L_ele'*sealNonLinear.damping_matrix*L_ele;        
           end
        
%% Add to global matrices
        M = self.rotor.matrices.M + M_bearing + M_disc + M_seal;
        C = self.rotor.matrices.D + C_bearing + D_seal;
        G = self.rotor.matrices.G + G_bearing + G_disc;
        K = self.rotor.matrices.K + K_bearing + K_disc + K_seal;

        
      
end