function [delta,nodePos]=get_distance_node_desired_position(rotor,desiredPos)
%GET_DISTANCE_NODE_DESIRED_POSITION - get the distance of the closest node to the desired node
% [delta,nodePos]=get_distance_node_desired_position(rotor,desiredPos)
% Get the distance between a desired position on the rotor and the nearest
% node of the finite element discretisation.
nodeNo = rotor.get_node_no(desiredPos);
nodePos = rotor.get_node_position(nodeNo);
delta = nodePos - desiredPos;
end