function nodePos = get_node_position(rotor,nodeNo)
%GET_NODE_POSITION - Get the corresponding position to a node number.
% nodePos = get_node_position(rotor,nodeNo)
nodePos = zeros(size(nodeNo));
for k = 1:length(nodeNo)
    nodePos(k) = rotor.mesh.nodes(nodeNo(k)).z;
end

end