function dataset = compose_data_sensor_wise(self)
% COMPOSE_DATA_SENSOR_WISE creates a container that includes the data of
% the sensors, ordered sensor wise
% AMrotorSIM.Dataoutput.TimeDataOutput/compose_data_sensor_wise 
%   dataset = compose_data_sensor_wise(self)
%   
%   dataset is a Map-object with the structure:
%                                   time (Nx1)
%       rpm  ->  sensorname     ->  x (Nx1)
%                                   y (Nx1)
%                                   sensor (object)
% 
%   See also KEYS, TIMEDATAOUTPUT, SAVE_DATA, CONVERT_DATASET_TO_STRUCT_SENSOR_WISE.
    disp(' --- Compose Dataset Timesignal  --- ')

    dataset = containers.Map('KeyType','double','ValueType','any');

    for drehzahl = self.experiment.drehzahlen 

        dataset(drehzahl)= containers.Map;
        tmp = dataset(drehzahl);
        

        for sensor = self.rotorsystem.sensors
            tmp(sensor.name) = containers.Map;
            tmp2 = tmp(sensor.name);
            [x_val,y_val,z_val]=...
            sensor.read_values(self.experiment);
            tmp2('sensor') = sensor;
            tmp2('time') = self.experiment.time;
            tmp2('x') = x_val(drehzahl);
            tmp2('y') = y_val(drehzahl); 
            tmp2('z') = z_val(drehzahl); 

        end

    end               
end