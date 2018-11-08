function Vpos = get_position_entries(obj,V)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    ind = n.nodes*2*2+1:n.nodes*2*4;
    Vpos = V(ind,:);
end