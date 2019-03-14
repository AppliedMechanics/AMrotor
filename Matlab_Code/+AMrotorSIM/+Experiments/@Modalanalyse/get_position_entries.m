function Vpos = get_position_entries(obj,V,mat)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.dofPerNode = length(mat.A)/n.nodes/2;
    ind = n.nodes*n.dofPerNode+1:n.nodes*2*n.dofPerNode;
    Vpos = V(ind,:);
end