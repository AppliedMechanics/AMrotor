function Vpos = get_position_entries(obj,V)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    ind = n.nodes*2*3+1:n.nodes*2*6;
    Vpos = V(ind,:);
end