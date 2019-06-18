function write_sensors_for_abravibe(r,rpm,filename)
% WRITE_SENSORS_FOR_ABRAVIBE
% generate data required for input in abravibe-functions mck2modal,
% mck2frf, ...
%
% write 
%  - system matrices M, D, K
%  - sensor-data in cells
%  - force-         sensor-node-nr in indof
%  - displacement-  sensor-node-nr in outdof
%  - velocity-      sensor-node-nr in outdof
%  - acceleration-  sensor-node-nr in outdof
%  - type contains types of outdof-sensors
%
% write_sensors_for_abravibe(r,rpm,filename)
% for expample: 
%  write_sensors_for_abravibe(r,0,'MLPS_abravibe_data.mat')

filename = [filename,'_rpm',num2str(rpm),'.mat'];

% Output für mck2frf erzeuegen
omega = rpm/60*2*pi;
[M,C,G,K]= r.assemble_system_matrices(rpm);
D = C+omega*G;
clear C G % avoids accidental mix-up of C,D,G
i = 1;
inNodeNr = [];
outNodeNr = [];
type =  [];
i_in=1;
i_out=1;
for sensor = r.sensors % build a struct with sensor properties
    sensTemp.name = sensor.name;
    sensTemp.unit = sensor.unit;
    sensTemp.Position = sensor.Position;
    sensTemp.measurementType = sensor.measurementType;
    sensTemp.node_nr = r.rotor.find_node_nr(sensor. Position);
    switch sensTemp.measurementType
        case 'Force'
            inNodeNr = [inNodeNr, sensTemp.node_nr];
            sens.in{i_in} = sensTemp;
            i_in = i_in+1;
        case 'Distance'
            outNodeNr = [outNodeNr, sensTemp.node_nr];
            type = [type, {'d'}];
            sens.out{i_out} = sensTemp;
            i_out = i_out+1;
        case 'Velocity'
            outNodeNr = [outNodeNr, sensTemp.node_nr];
            type = [type, {'v'}];
            sens.out{i_out} = sensTemp;
            i_out = i_out+1;
        case 'Acceleration'
            outNodeNr = [outNodeNr, sensTemp.node_nr];
            type = [type, {'a'}];
            sens.out{i_out} = sensTemp;
            i_out = i_out+1;
    end
    i = i+1;
end

M = sparse(M);
D = sparse(D);
K = sparse(K);

for i=1:length(inNodeNr)
indof.u_x(i) = r.rotor.get_gdof('u_x',inNodeNr(i));
indof.u_y(i) = r.rotor.get_gdof('u_y',inNodeNr(i));
indof.u_z(i) = r.rotor.get_gdof('u_z',inNodeNr(i));
indof.psi_x(i) = r.rotor.get_gdof('psi_x',inNodeNr(i));
indof.psi_y(i) = r.rotor.get_gdof('psi_y',inNodeNr(i));
indof.psi_z(i) = r.rotor.get_gdof('psi_z',inNodeNr(i));
end

for i=1:length(outNodeNr)
outdof.u_x(i) = r.rotor.get_gdof('u_x',outNodeNr(i));
outdof.u_y(i) = r.rotor.get_gdof('u_y',outNodeNr(i));
outdof.u_z(i) = r.rotor.get_gdof('u_z',outNodeNr(i));
outdof.psi_x(i) = r.rotor.get_gdof('psi_x',outNodeNr(i));
outdof.psi_y(i) = r.rotor.get_gdof('psi_y',outNodeNr(i));
outdof.psi_z(i) = r.rotor.get_gdof('psi_z',outNodeNr(i));
end

z = zeros(length(r.rotor.mesh.nodes),1);
for i=1:length(z)
    z(i) = r.rotor.mesh.nodes(i).z;
end

save(filename,'M','D','K','z','indof','outdof','inNodeNr','outNodeNr','type','sens')

end

