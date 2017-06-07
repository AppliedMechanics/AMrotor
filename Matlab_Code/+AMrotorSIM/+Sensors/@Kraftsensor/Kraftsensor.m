classdef Kraftsensor < AMrotorSIM.Sensors.Sensor
   properties
       Unit = 'N'
       AxialPosition % Sensor Position in axial direction
       %Bearings % 1xN AMrotorSIM.Bearings.Lager
   end
   methods
        function self = Kraftsensor(sensorConfig, bearings) 
           self = self@AMrotorSIM.Sensors.Sensor(sensorConfig);
           self.AxialPosition = sensorConfig.position;
        end 
        
        function force = measure_force(self, rotorsystem)
            % Type abfragen, hier geht nur typ 1
            for bearing = rotorsystem.lager  % Check for every Sensor if following is true
                if bearing.type == 1
                   if self.AxialPosition == bearing.position  % If the Sensor is at the same position as a bearing
                        [x_pos,beta_pos,y_pos,alpha_pos] = displacement_calc_at_pos(self.AxialPosition, rotorsystem);
                        [M,G,D,K] = compute_matrices(bearing);
                        force = [x_pos, y_pos] * K
                        return
                    else 
                        force = 0
                   end
                else
                    disp ('Forcesensor for Type 2 and 3 Bearing not implemented yet')
                end
            end
           
        end
          
     end
end
