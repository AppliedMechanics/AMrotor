function L_glob = create_glob_loc_matrix(self)

n_nodes=length(self.rotor.mesh.nodes);
node = self.rotor.find_node_nr(self.position);
glob_dof = self.rotor.get_gdof(self.direction,node);

% localisation matrix is only a vector
L_glob = sparse(6,6*n_nodes);
L_glob(glob_dof) = 1;

self.globalLocalisationMatrix = L_glob;
end