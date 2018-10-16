function Vpos = getPositionEntries(obj,V)
    n.nodes = length(obj.rotorSystem.rotor.mesh.nodes);
    ind = n.nodes*2*2+1:n.nodes*2*4;
    Vpos = V(ind,:);
end