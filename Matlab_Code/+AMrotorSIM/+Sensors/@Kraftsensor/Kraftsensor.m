classdef Kraftsensor < AMrotorSIM.Sensors.Sensor
   properties
       Unit = 'N'
       AxialPosition % Sensor Position in axial direction
       %Bearings % 1xN AMrotorSIM.Bearings.Lager
       MeasurementType = 'Force'
   end
   methods
        function self = Kraftsensor(sensorConfig, bearings) 
           self = self@AMrotorSIM.Sensors.Sensor(sensorConfig);
           self.AxialPosition = sensorConfig.position;
        end 
        
        function [x_val, y_val, z_val] = measure_force(self, rotorsystem)
             for bearing = rotorsystem.lager  % Check for every Sensor if following is true
                if bearing.type == 1
                   if self.AxialPosition == bearing.position  % If the Sensor is at the same position as a bearing
                        [x_pos,beta_pos,y_pos,alpha_pos] = displacement_calc_at_pos(self.AxialPosition, rotorsystem);
                        
                        
                        [M,G,D,K] = compute_matrices(bearing);
                        j = 1;
                        x_force = [];
                        y_force = [];
                        z_force = [];
                        while j ~= length(x_pos)
                            forces = [x_pos(j),0, y_pos(j)] * K;
                            j = j+1 ;
                            x_force(j) = forces(1);
                            y_force(j) = forces(3);
                            z_force(j) = forces(2);
                        end
                        x_val = x_force;
                        y_val = y_force;
                        z_val = z_force;
                        return
                    else 
                        x_val = 0;
                        y_val = 0;
                        z_val = 0;
                   end
                else
                    disp ('Forcesensor for Type 2 and 3 Bearing not implemented yet')
                end
            end
           
        end
          
     end
end
