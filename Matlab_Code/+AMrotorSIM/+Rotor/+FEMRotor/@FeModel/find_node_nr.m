function node_nr = find_node_nr(self,position)

    for i = 2:length(self.mesh.nodes)
        if self.mesh.nodes(1,i-1).z < position < self.mesh.nodes(1,i).z
           if position - self.mesh.nodes(1,i-1).z < self.mesh.nodes(1,i).z - position
                node_nr = self.mesh.nodes(1,i-1).name;
                break
           else
                node_nr = self.mesh.nodes(1,i).name;
                break
           end
        elseif position == self.mesh.nodes(1,i-1).z 
            node_nr = self.mesh.nodes(1,i-1).name;
            break
        elseif position == self.mesh.nodes(1,i).z 
            node_nr = self.mesh.nodes(1,i).name;
            break
        end
    end
end