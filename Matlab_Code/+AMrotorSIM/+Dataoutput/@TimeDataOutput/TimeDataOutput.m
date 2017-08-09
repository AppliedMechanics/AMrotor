classdef TimeDataOutput < handle
    % Dataset n x i x m
    properties
        rotorsystem
        drehzahlen
        dataset
        solution
    end
    
    methods
        function self= TimeDataOutput(r, solution)  
            self.rotorsystem = r;
            self.solution = solution;
            self.drehzahlen = solution.drehzahl;
        end
        
        function dataset = aquire_data(self)
         
            disp(' --- Compose Dataset Timesignal  --- ')
            
         sensor_value_names = {'s_x','s_y','s_beta','s_alpha','F_x',...
                        'F_y','v_x','v_y','a_x','a_y','Phi','Phi_d'};
         sensor_values = cell(1,length(sensor_value_names));
         sensor_data = containers.Map(sensor_value_names,sensor_values);         

         j = 1;
         data_cell = {};
         for drehzahl = self.drehzahlen
             data_cell{1,j} = sensor_data;
             j = j+1;
         end
         dataset = containers.Map(self.drehzahlen, data_cell);

            for drehzahl = self.drehzahlen     
                tmp = dataset(drehzahl);
                
                    ds = self.solution.result(drehzahl);
                tmp('Phi')= ds{4};
                tmp('Phi_d')= ds{5};
                
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
