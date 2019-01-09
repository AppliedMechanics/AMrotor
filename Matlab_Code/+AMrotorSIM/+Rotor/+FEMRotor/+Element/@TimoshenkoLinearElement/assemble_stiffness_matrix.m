function [K] = assemble_stiffness_matrix(self)
            
            K_A = compute_axial_stiffness_matrix(self);
            K_T = compute_torsional_stiffness_matrix(self);
            [K_F1, K_F2] = compute_bending_stiffness_matrix(self);
            
            K = zeros(12,12);
            
            K(1:2,1:2) = K_A;
            K(3:4,3:4) = K_T;
            K(5:8,5:8) = K_F1;
            K(9:12,9:12) = K_F2;
            
            self.stiffness_matrix = K;
        end