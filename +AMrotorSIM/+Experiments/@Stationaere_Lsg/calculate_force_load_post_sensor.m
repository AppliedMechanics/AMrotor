function F = calculate_force_load_post_sensor(obj,displacement,velocity)
% calculate the force of the sensor ForceLoadPostSensor
%   Uses the displacment and velocity to obtain the force of
%   the corresponding load-objects, through their force laws
F = zeros(size(displacement,1),size(displacement,2));
% Kraftberechnung
if any(strcmp({obj.rotorsystem.sensors.type},'ForceLoadPostSensor'))
    h_ges = zeros(2*size(displacement,1),size(displacement,2));
    for k = 1:length(obj.time)
        h_ges(:,k) = obj.rotorsystem.compute_system_load_variant(obj.time(k), [displacement(:,k); velocity(:,k)]);
    end
    F = h_ges(end/2+1:end,:);
end

end