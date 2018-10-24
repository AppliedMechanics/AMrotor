function [M_bearing,D_bearing,K_bearing] = calculate_bearing_matrices(obj,rpm)
%CALCULATE_BEARING_MATRICES Computes the bearing matrices in the global form
%   [M_bearing,D_bearing,K_bearing] = add_bearing_matrices(obj,rpm)
%   Adds the bearing matrices to the input systemmatrices in
%   obj.rotorsystem.systemmatrices calls the new systemmatrices M_out,
%   D_out, K_out. Seal matrices are dependent on the rotational speed rpm
%   (in 1/min). 

n_nodes=length(obj.rotorsystem.rotor.mesh.nodes);
M_bearing = sparse(6*n_nodes,6*n_nodes);
D_bearing = sparse(6*n_nodes,6*n_nodes);
K_bearing = sparse(6*n_nodes,6*n_nodes);
  
   for bearing = obj.rotorsystem.bearings
        if strcmp(bearing.type,'LookUpTableBearing') 
            %Do build systemmatrices here only if bearing is of type 'LookUpTableBearing', i.e. if systemmatrices are rpm-dependent
            bearing.create_ele_loc_matrix;
            bearing.get_loc_gyroscopic_matrix(rpm);
            bearing.get_loc_damping_matrix(rpm); 
            bearing.get_loc_mass_matrix(rpm);
            bearing.get_loc_stiffness_matrix(rpm);

            bearing_node = obj.rotorsystem.rotor.find_node_nr(bearing.position);
            L_ele = sparse(6,6*n_nodes);
            L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;

            M_bearing = M_bearing+L_ele'*bearing.mass_matrix*L_ele;
            K_bearing = K_bearing+L_ele'*bearing.stiffness_matrix*L_ele;
            D_bearing = D_bearing+L_ele'*bearing.damping_matrix*L_ele;            
        end
        
   end

   
end

