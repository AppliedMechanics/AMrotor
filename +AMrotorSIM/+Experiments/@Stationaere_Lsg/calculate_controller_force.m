function F = calculate_controller_force(obj,displacement,velocity)
% calculate the force of the sensor ControllerForceSensor
%   Uses the displacment and velocity to obtain the force of
%   the corresponding pidControllers
F = zeros(size(displacement,1),size(displacement,2));

if any(strcmp({obj.rotorsystem.sensors.type},'ControllerForceSensor'))
    h_ges = zeros(size(displacement,1),size(displacement,2));
    for k = 1:length(obj.time)
        % set the new controller force
        for cntr = obj.rotorsystem.pidControllers
            [displacementCntrNode, ~] = obj.rotorsystem.find_state_vector(cntr.position, [displacement(:,k); velocity(:,k)]);
            cntr.get_controller_force(obj.time(k),displacementCntrNode); 
        end
        h_ges(:,k) = obj.rotorsystem.assemble_system_controller_forces();
    end
    F = h_ges;
end

end