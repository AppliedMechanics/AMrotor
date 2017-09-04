classdef Kraftsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'N'
       Position % Sensor Position in axial direction
       %Bearings % 1xN AMrotorSIM.Bearings.Lager
       measurementType = 'Force'
   end
   methods
        function self = Kraftsensor(sensorConfig) 
           self = self@AMrotorSIM.Sensors.Sensor(sensorConfig);
           self.Position = sensorConfig.position;
        end 
        
        function [x_val, y_val] = measure_force(self, experiment)
             for bearing = experiment.rotorsystem.lager  % Check for every Sensor if following is true
                if bearing.type == 1
                   if self.Position == bearing.position  % If the Sensor is at the same position as a bearing
                        %[x_pos,beta_pos,y_pos,alpha_pos] = displacement_calc_at_pos(self.Position, experiment);
                        
                        %Künstlichen Wegsensor installieren
                        
                          cnfg_w.name = 'Artificial Sensor';
                          cnfg_w.position=self.Position;
                          cnfg_w.type=1;
                          
                        w = AMrotorSIM.Sensors.Wegsensor(cnfg_w);
                        [x_pos,beta_pos,y_pos,alpha_pos] = w.read_values(experiment);
                        
                        x_val = containers.Map('KeyType','double','ValueType','any');
                        y_val = containers.Map('KeyType','double','ValueType','any');
                        
                        for drehzahl = experiment.drehzahlen
                        x_val(drehzahl) = x_pos(drehzahl)*bearing.cnfg.stiffness;
                        y_val(drehzahl) = y_pos(drehzahl)*bearing.cnfg.stiffness;
                        end
                        
                        return
                    else 
                        x_val = 0;
                        y_val = 0;
                   end
                else
                    disp ('Forcesensor for Type 2 and 3 Bearing not implemented yet')
                end
            end
           
        end
          
     end
end
