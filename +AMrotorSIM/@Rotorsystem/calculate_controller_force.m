function F = calculate_controller_force(rotorsystem,time,displacement,velocity)
% calculate the force of the sensor ControllerForceSensor
%   Uses the displacment and velocity to obtain the force of
%   the corresponding pidControllers
F = zeros(size(displacement,1),size(displacement,2));

if any(strcmp({rotorsystem.sensors.type},'ControllerForceSensor'))
    h_ges = zeros(size(displacement,1),size(displacement,2));
    for k = 1:length(time)
        Zk = [displacement(:,k); velocity(:,k)];
        % set the new controller force
        for cntr = rotorsystem.pidControllers
            [displacementCntrNode, ~] = rotorsystem.find_state_vector(cntr.position, Zk);
            cntr.get_controller_current(time(k),displacementCntrNode); 
            cntr.get_controller_force(time(k),displacementCntrNode); 
        end
        h_ges(:,k) = rotorsystem.assemble_system_controller_forces(time(k),Zk);
    end
    F = h_ges;
end

end