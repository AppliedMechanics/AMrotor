% Licensed under GPL-3.0-or-later, check attached LICENSE file

function F = calculate_force_load_post_sensor(rotorsystem,time,displacement,velocity)
% Calculate the force of the sensor ForceLoadPostSensor
%
%    :param rotorsystem: Object of type rotorsystem
%    :type rotorsystem: object
%    :param time: Time step
%    :type time: double
%    :param displacement: Displacement vector
%    :type displacement: vector(double)
%    :param velocity: Velocity vector
%    :type velocity: vector(double)
%    :return: ControllerForceSensor force

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