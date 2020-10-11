% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [delta,nodePos]=get_distance_node_desired_position(rotor,desiredPos)
% Gets the distance of the closest actual node to the desired node
%
%    :parameter rotor: Object of type AMrotorSIM.Rotor.FEMRotor.FeModel
%    :type rotor: object
%    :parameter desiredPos: Desired position along z-axis
%    :type desiredPos: vector
%    :return: Actual position (closest node) and delta distance between desired and actual position [delta,nodePos]
%    :rtype: vector

% [delta,nodePos]=get_distance_node_desired_position(rotor,desiredPos)
% Get the distance between a desired position on the rotor and the nearest
% node of the finite element discretisation.
nodeNo = rotor.get_node_no(desiredPos);
nodePos = rotor.get_node_position(nodeNo);
delta = nodePos - desiredPos;
end