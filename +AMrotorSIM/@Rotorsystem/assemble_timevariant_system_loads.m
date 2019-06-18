function assemble_timevariant_system_loads(self,time)

    h=self.systemmatrices.h;

    n_nodes=length(self.rotor.mesh.nodes);
            
%% Lastvektoren für jede Last aufaddieren            
            
            for load = self.loads
                
                load.create_ele_loc_matrix
                load.get_loc_timeload_vec(time)
                
                load_node = self.rotor.find_node_nr(load.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(load_node-1)*6+1:(load_node-1)*6+6)=load.localisation_matrix;
                
                    fields = fieldnames(h);
                    for j=1:numel(fields)
                        h.(fields{j})=h.(fields{j})+L_ele'*load.h.(fields{j});
                    end

            end
        
%% Gesamtvektor addieren
        
        fields = fieldnames(h);
        for j=1:numel(fields)
            self.systemmatrices.h.(fields{j})=h.(fields{j});
        end
        
      
end