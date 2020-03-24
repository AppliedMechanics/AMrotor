function [deltaIn,deltaOut] = print_distance_delta(obj)
% gives the distance between the desired z-position and the position of the
% closest node
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