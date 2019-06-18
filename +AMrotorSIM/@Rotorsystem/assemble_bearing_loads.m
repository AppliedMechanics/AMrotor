function assemble_bearing_loads(self, Z, omega)

    h=self.systemmatrices.h;

    n_nodes=length(self.rotor.mesh.nodes);
    
    rpm = omega*60/2/pi;
            
%% Lastvektoren für jede Last aufaddieren            
            
            for bearing = self.bearings
                if strcmp(bearing.type,'LimSinghBearing')
                
                u = [];
                
                bearing_node = self.rotor.find_node_nr(bearing.position);
                
                dof_u_x = self.rotor.get_gdof('u_x',bearing_node);
                dof_u_z = self.rotor.get_gdof('u_z',bearing_node);
                dof_psi_x = self.rotor.get_gdof('psi_x',bearing_node);
                dof_psi_z = self.rotor.get_gdof('psi_z',bearing_node);
                u = Z(dof_u_x:dof_u_z);
                psi = wrapTo2Pi(Z(dof_psi_x:dof_psi_z));
                u = [u; psi];
                
                bearing.create_ele_loc_matrix
                F = bearing.get_loc_force(rpm, u);
                                
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;
                
                h.h = h.h + L_ele' * F;
%                 fields = fieldnames(h);
%                     for j=1:numel(fields)
%                         h.(fields{j})=h.(fields{j})+L_ele'*load.h.(fields{j});
%                     end
                end

            end
        
%% Gesamtvektor addieren
        
     self.systemmatrices.h.h=self.systemmatrices.h.h + h.h;
        
      
end