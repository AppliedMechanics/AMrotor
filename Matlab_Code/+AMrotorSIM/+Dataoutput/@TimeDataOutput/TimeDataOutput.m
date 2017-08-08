classdef TimeDataOutput < handle
    % Dataset n x i x m
    properties
        rotorsystem
        drehzahlen
        dataset
    end
    
    methods
        function self= TimeDataOutput(a, experiment)  
            self.rotorsystem = a;
            self.drehzahlen = experiment.drehzahl;
        end
        
        function aquire_data(self)
                   
         sensor_value_names = {'s_x','s_y','s_beta','s_alpha','F_x',...
                        'F_y','v_x','v_y','a_x','a_y'};
         sensor_values = cell(1,length(sensor_value_names));
         sensor_data = containers.Map(sensor_value_names,sensor_values);         

         j = 1;
         data_cell = {};
         for drehzahl = self.drehzahlen
             data_cell{1,j} = sensor_data;
             j = j+1;
         end
         self.dataset = containers.Map(self.drehzahlen, data_cell);

            for drehzahl = self.drehzahlen     
                tmp = self.dataset(drehzahl);
                for sensor = self.rotorsystem.sensors
                    
                    [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);

                    switch sensor.type
                        case 1 %Wegsensor
                            tmp('s_x') = x_val;
                            tmp('s_y') = y_val;
                            tmp('s_beta') = beta_pos;
                            tmp('s_alpha') = alpha_pos;
                        case 2 %Kraftsensor
                            tmp('F_x') = x_val;
                            tmp('F_y') = y_val;
                        case 3 %Geschwindigkeitssensor
                            tmp('v_x') = x_val;
                            tmp('v_y') = y_val;
                        case 4 %Beschleunigungssensor
                            tmp('a_x') = x_val;
                            tmp('a_y') = y_val;
                    end
                                    
                end
            end               
        end
    end
    
end
