classdef TimeDataOutput < handle
    % Dataset n x i x m
    properties
        rotorsystem
        experiment
        dataset
    end
    
    methods
        function self= TimeDataOutput(r, experiment)  
            self.rotorsystem = r;
            self.experiment = experiment;
       end
        
        function dataset = aquire_data(self)
         
            disp(' --- Compose Dataset Timesignal  --- ')
            
          sensor_value_names = {'n'};
         
         sensor_values = cell(1,1);

         dataset = containers.Map('KeyType','double','ValueType','any');
         for drehzahl = self.experiment.drehzahl
          dataset(drehzahl)= containers.Map(sensor_value_names,sensor_values);
         end

            for drehzahl = self.experiment.drehzahl     
                tmp = dataset(drehzahl);
                
                    ds = self.experiment.result(drehzahl);
                tmp('Phi')= ds{4};
                tmp('Phi_d')= ds{5};
                
                for sensor = self.rotorsystem.sensors
                    [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);

                    switch sensor.type
                        case 1 %Wegsensor
                            tmp(['s_x (',sensor.name,')']) = x_val;
                            tmp(['s_y (',sensor.name,')']) = y_val;
                            tmp(['s_beta (',sensor.name,')']) = beta_pos;
                            tmp(['s_alpha (',sensor.name,')']) = alpha_pos;
                        case 2 %Kraftsensor
                            tmp(['F_x (',sensor.name,')']) = x_val;
                            tmp(['F_y (',sensor.name,')']) = y_val;
                        case 3 %Geschwindigkeitssensor
                            tmp(['v_x (',sensor.name,')']) = x_val;
                            tmp(['v_y (',sensor.name,')']) = y_val;
                        case 4 %Beschleunigungssensor
                            tmp(['a_x (',sensor.name,')']) = x_val;
                            tmp(['a_y (',sensor.name,')']) = y_val;
                    end
                                    
                end
                tmp('n')= ones(1, length(x_val))*drehzahl;
                tmp('time') = self.experiment.time;
            end               
        end
    end
    
end
