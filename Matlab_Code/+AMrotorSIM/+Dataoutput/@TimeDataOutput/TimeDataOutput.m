classdef TimeDataOutput < handle

    properties
        rotorsystem
        experiment_result
        experiment
        dataset
    end
    
    methods
        function self= TimeDataOutput(experiment)  
            self.experiment = experiment;
            self.rotorsystem = experiment.rotorsystem;
            self.experiment_result = experiment.result;
       end
        
        function dataset = compose_data(self)
         
            disp(' --- Compose Dataset Timesignal  --- ')

         dataset = containers.Map('KeyType','double','ValueType','any');
         
            for drehzahl = self.experiment.drehzahlen 
                
                dataset(drehzahl)= containers.Map;
                tmp = dataset(drehzahl);
                
                ds = self.experiment_result(drehzahl);
                
                tmp('n')= ones(1, length(self.experiment.time))*drehzahl;
                tmp('time') = self.experiment.time;
                
                tmp('Phi')= ds.Phi;
                tmp('Phi_d')= ds.Phi_d;
 
                for sensor = self.rotorsystem.sensors
                    [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.experiment);

                    switch sensor.type
                        case 1 %Wegsensor
                            tmp(['s_x (',sensor.name,')']) = x_val(drehzahl);
                            tmp(['s_y (',sensor.name,')']) = y_val(drehzahl);
                            tmp(['s_beta (',sensor.name,')']) = beta_pos(drehzahl);
                            tmp(['s_alpha (',sensor.name,')']) = alpha_pos(drehzahl);
                        case 2 %Kraftsensor
                            tmp(['F_x (',sensor.name,')']) = x_val(drehzahl);
                            tmp(['F_y (',sensor.name,')']) = y_val(drehzahl);
                        case 3 %Geschwindigkeitssensor
                            tmp(['v_x (',sensor.name,')']) = x_val(drehzahl);
                            tmp(['v_y (',sensor.name,')']) = y_val(drehzahl);
                        case 4 %Beschleunigungssensor
                            tmp(['a_x (',sensor.name,')']) = x_val(drehzahl);
                            tmp(['a_y (',sensor.name,')']) = y_val(drehzahl);
                    end
                                    
                end

            end               
        end
    end
    
end
