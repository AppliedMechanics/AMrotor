function assemble_invariant_system_loads(self)
    
%% Lastvektoren einzelner Elemente erstellen

            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Einträge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

            h.h = sparse(6*n_nodes,1);   

            %centripetal-force unbalance, rotating
            h.h_ZPsin = h.h;                                      
            h.h_ZPcos = h.h;   

            %unbalance mass inertia force 
            h.h_DBsin = h.h;                                 
            h.h_DBcos = h.h;

            %Constant_fix_force   e.g weight force
            h.h_sin = h.h;                     
            h.h_cos = h.h;

            %rotating_fix_force   e.g  bearing exitation 
            h.h_rotsin = h.h;                   
            h.h_rotcos = h.h;
            
%% Lastvektoren für jede Last aufaddieren            
            
            for load = self.loads
                
                load.create_ele_loc_matrix
                load.get_loc_load_vec
                
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