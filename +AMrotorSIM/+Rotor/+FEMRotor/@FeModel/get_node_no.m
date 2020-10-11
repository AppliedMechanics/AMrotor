% Licensed under GPL-3.0-or-later, check attached LICENSE file

function nodeNo = get_node_no(rotor,position)
% Gets the node number that is closest to a desired position
%
%    :parameter rotor: Object of type AMrotorSIM.Rotor.FEMRotor.FeModel
%    :type rotor: object
%    :parameter position: Desired position along z-axis
%    :type position: vector 
%    :return: Number of closest node to desired position

% nodeNo = get_node_no(rotor,position)
nodeNo = zeros(size(position));
for k = 1:length(position)
    nodeNo(k) = rotor.find_node_nr(position(k));
end

end

