function get_sensor_mesh_position(rotorsystem)
rotor = rotorsystem.rotor;
for sensor = rotorsystem.sensors
    nodeNo = rotor.get_node_no(sensor.position);
    sensor.positionMesh  = rotor.get_node_position(nodeNo);
end
end