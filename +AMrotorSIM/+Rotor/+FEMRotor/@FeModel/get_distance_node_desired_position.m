function [delta,nodePos]=get_distance_node_desired_position(rotor,desiredPos)
nodeNo = rotor.get_node_no(desiredPos);
nodePos = rotor.get_node_position(nodeNo);
delta = nodePos - desiredPos;
end