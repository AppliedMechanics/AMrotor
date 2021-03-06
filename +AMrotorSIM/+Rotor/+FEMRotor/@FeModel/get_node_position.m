function nodePos = get_node_position(rotor,nodeNo)
% Gets the corresponding position to a node number
%
%    :parameter rotor: Object of type AMrotorSIM.Rotor.FEMRotor.FeModel
%    :type rotor: object
%    :parameter nodeNo: Desired node number
%    :type nodeNo: vector
%    :return: Position along z-axis of desired node

% Licensed under GPL-3.0-or-later, check attached LICENSE file

% nodePos = get_node_position(rotor,nodeNo)
nodePos = zeros(size(nodeNo));
for k = 1:length(nodeNo)
    nodePos(k) = rotor.mesh.nodes(nodeNo(k)).z;
end

end