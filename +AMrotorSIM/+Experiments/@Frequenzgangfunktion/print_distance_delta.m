% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [deltaIn,deltaOut] = print_distance_delta(obj)
% Gives the distance between the desired z-position and the z-position of the closest node
%
%    :return: Delta distance from the desired in- and output positions to the real in- and output positions (deltaIn,deltaOut)

rotor = obj.rotorsystem.rotor;
inPos = obj.inputPosition;
outPos = obj.outputPosition;
[deltaIn,nodePosIn]=rotor.get_distance_node_desired_position(inPos);
[deltaOut,nodePosOut]=rotor.get_distance_node_desired_position(outPos);

% Input
fprintf('INPUT\n')
obj.print_table(inPos, nodePosIn, deltaIn)

disp(' ') % skip line

% Output
fprintf('OUTPUT\n')
obj.print_table(outPos, nodePosOut, deltaOut)

end