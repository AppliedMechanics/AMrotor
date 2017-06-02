classdef Kraftsensor < AMrotorSIM.Sensors.Sensor
   properties
       Unit = 'N'
       AxialPosition % Sensor Position in axial direction
       Bearings % 1xN AMrotorSIM.Bearings.Lager
   end
   methods
        function self = Kraftsensor(sensorConfig, bearings) 
           self = self@AMrotorSIM.Sensors.Sensor(sensorConfig);
           self.AxialPosition = sensorConfig.position;
           self.Bearings =  bearings;
        end 
        
        function force = measure(self, rotorsystem)
            % Type abfragen, hier geht nur typ 1
          for bearing = self.Bearings  % Check for every Sensor if following is true
           if self.AxialPosition == bearing.position  % If the Sensor is at the same position as a bearing
            [x_pos,beta_pos,y_pos,alpha_pos] = displacement_calc_at_pos(self.AxialPosition, rotorsystem);
         	K = compute_stiffness_matrix(rotorsystem.cnfg, rotorsystem.moment_of_inertia, rotorsystem.nodes);
            return
           else 
                force = 0;
           end
          end 
           
        end
   end
end