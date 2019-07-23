function F = calculate_force_load_post_sensor(rotorsystem,time,displacement,velocity)
% calculate the force of the sensor ForceLoadPostSensor
%   Uses the displacment and velocity to obtain the force of
%   the corresponding load-objects, through their force laws
F = zeros(size(displacement,1),size(displacement,2));
% Kraftberechnung
if any(strcmp({rotorsystem.sensors.type},'ForceLoadPostSensor'))
    h_ges = zeros(size(displacement,1),size(displacement,2));
    for k = 1:length(time)
        h_ges(:,k) = rotorsystem.assemble_system_loads(time(k), [displacement(:,k); velocity(:,k)]);
    end
    F = h_ges;
end
end