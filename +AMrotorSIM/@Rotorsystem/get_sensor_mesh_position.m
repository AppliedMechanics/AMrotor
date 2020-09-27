% Licensed under GPL-3.0-or-later, check attached LICENSE file

function get_sensor_mesh_position(rotorsystem)
% Gives the rotor mesh node corresponding to the sensor regarding the position
%
%    :param rotorsystem: Object of type rotorsystem
%    :type rotorsystem: object
%    :return: BearingForceSensor force

rotor = rotorsystem.rotor;
for sensor = rotorsystem.sensors
    nodeNo = rotor.get_node_no(sensor.position);
    sensor.positionMesh  = rotor.get_node_position(nodeNo);
end
end