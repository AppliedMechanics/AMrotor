% Licensed under GPL-3.0-or-later, check attached LICENSE file

function dataset = compose_data(self)
% Creates a container that includes the data of the sensors
%
%    :return: dataset (Map-object)

% AMrotorSIM.Dataoutput.TimeDataOutput/compose_data 
%   dataset = compose_data(self)
% 
%   See also TIMEDATAOUTPUT, SAVE_DATA.
    disp(' --- Compose Dataset Timesignal  --- ')

    dataset = containers.Map('KeyType','double','ValueType','any');

    for drehzahl = self.experiment.drehzahlen 

        dataset(drehzahl)= containers.Map;
        tmp = dataset(drehzahl);

        tmp('n')= ones(1, length(self.experiment.time))*drehzahl;
        tmp('time') = self.experiment.time;

        for sensor = self.rotorsystem.sensors
            [x_val,y_val,z_val]=...
            sensor.read_values(self.experiment);

            tmp(['x-dir (',sensor.name,')']) = x_val(drehzahl);
            tmp(['y-dir (',sensor.name,')']) = y_val(drehzahl);
            tmp(['z-dir (',sensor.name,')']) = z_val(drehzahl);

        end

    end               
end