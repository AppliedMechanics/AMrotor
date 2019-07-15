function print_table(obj,desiredPosition, nodePosition, deltaPosition)
% show the distance between the desired axial positions on the rotor and
% the closest nodes of the rotor mesh
%   print_table(obj,desiredPosition, nodePosition, deltaPosition)
for i=1:length(deltaPosition)
    fprintf('%2d \t\t | \t %3.0f mm \t | \t %3.2f mm \t\t | \t %3.2f mm\n',...
        i, desiredPosition(i)*1e3, nodePosition(i)*1e3, deltaPosition(i)*1e3);
end

end