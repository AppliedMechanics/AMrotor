function node_nr = find_node_nr(self,fe_model,position)

    for i = 2:length(fe_model.mesh.nodes)
        if fe_model.mesh.nodes(1,i-1).z < position < fe_model.mesh.nodes(1,i).z
           if position - fe_model.mesh.nodes(1,i-1).z < fe_model.mesh.nodes(1,i).z - position
                node_nr = fe_model.mesh.nodes(1,i-1).name;
           else
                node_nr = fe_model.mesh.nodes(1,i).name;
           end
        elseif position == fe_model.mesh.nodes(1,i-z).z 
            node_nr = fe_model.mesh.nodes(1,i-1).name;
        else
            node_nr = fe_model.mesh.nodes(1,i).name;
        end
    end
end