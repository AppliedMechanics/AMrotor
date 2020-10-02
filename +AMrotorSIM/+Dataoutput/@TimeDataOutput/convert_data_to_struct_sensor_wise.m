% Licensed under GPL-3.0-or-later, check attached LICENSE file

function struct = convert_data_to_struct_sensor_wise(self,dataset)
% Converts data container to struct
%
%    :return: Struct with sensor data

% convert_data_to_struct_sensor_wise convert container.Map to struct sensor 
%   wise for dataset, that was constructed
%   by AMrotorSIM.Dataoutput.TimeDataOutput/compose_data_sensor_wise 
%
% AMrotorSIM.Dataoutput.TimeDataOutput/convert_data_to_struct_sensor_wise
%   struct = convert_data_to_struct_sensor_wise(dataset)
%   
%   struct with structure (e.g.):
%       struct.rpm
%             .data.<| name (string)  
%                    | sensor (object)
%                    | time (Nx1)
%                    | x (Nx1)
%                    | y (Nx1)
% 
%   See also KEYS, TIMEDATAOUTPUT, SAVE_DATA, COMPOSE_DATA_SENSOR_WISE.
    disp(' --- Convert Dataset Timesignal  --- ')

    drehzahlen = keys(dataset);

    for i=1:length(drehzahlen)
        drehzahl = drehzahlen{i};
        currDataset = dataset(drehzahl);
        sensornames = keys(currDataset);
        
        struct(i).rpm = drehzahl;
        
       
        for j = 1:length(sensornames)
            sensorname = sensornames{j};
            sensorSubset = currDataset(sensorname);
            
            sensor = sensorSubset('sensor');
            struct(i).data(j).name = sensor.name;
            struct(i).data(j).sensor = sensor;
            struct(i).data(j).time = sensorSubset('time');
            struct(i).data(j).x = sensorSubset('x');
            struct(i).data(j).y = sensorSubset('y');
            struct(i).data(j).z = sensorSubset('z');

        end

    end               
end