function nodeNo = get_node_no(rotor,position)
%GET_NODE_NO 
% Get the node number that is closest to the desired position.
nodeNo = zeros(size(position));
for k = 1:length(position)
    nodeNo(k) = rotor.find_node_nr(position(k));
end

end

