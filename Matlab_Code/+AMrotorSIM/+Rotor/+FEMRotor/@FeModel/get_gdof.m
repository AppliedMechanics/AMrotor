function glob_dof = get_gdof(self,direction,Node,mat)
    dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
    dof_loc = [1,2,3,4,5,6];
    
    ldof = containers.Map(dof_name,dof_loc);
    
    
    if ischar(direction) == 1 
        entry_nr = ldof(direction);
    else
        error('Error: The first entry of get_gdof() has to be a string');
    end
        
    if isempty(find(ismember(dof_name,direction))) == 1
        error ('Error: Input not existent as a degree of freedom')
    end
    
    % falls weniger als 6 dof benutzt werden
    n.nodes = length(self.mesh.nodes);
    n.dofPerNode = length(mat.A)/n.nodes/2;
    
    glob_dof = (Node-1)*n.dofPerNode+entry_nr;
   
end