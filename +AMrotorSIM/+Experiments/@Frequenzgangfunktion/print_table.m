function print_table(obj,desiredPosition, nodePosition, deltaPosition)
% Builds the printing frame
%
%    :param desiredPosition: Desired position of in- or output (FRF) along z-axis
%    :type desiredPosition: double
%    :param nodePosition: Closest node available next to the desired position along z-axis
%    :type nodePosition: double
%    :param deltaPosition: Difference between desired and available (node) position alon z-axis
%    :type deltaPosition: double
%    :return: Print of all the parameters in the Command Window

% show the distance between the desired axial positions on the rotor and
% the closest nodes of the rotor mesh
%   print_table(obj,desiredPosition, nodePosition, deltaPosition)
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

fprintf('      \t | \t desired \t | \t closest node \t | delta\n')
fprintf('--------------------------------------------------------\n')
for i=1:length(deltaPosition)
    fprintf('%2d \t\t | \t %3.0f mm \t | \t %3.2f mm \t\t | \t %3.2f mm\n',...
        i, desiredPosition(i)*1e3, nodePosition(i)*1e3, deltaPosition(i)*1e3);
end

end