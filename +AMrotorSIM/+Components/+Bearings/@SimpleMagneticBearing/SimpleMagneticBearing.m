classdef SimpleMagneticBearing < AMrotorSIM.Components.Bearings.Bearing
   properties
        cnfg
   end
   methods
        function obj=SimpleMagneticBearing(arg) 
           obj = obj@AMrotorSIM.Components.Bearings.Bearing(arg);
           obj.cnfg = arg;
           obj.color = 'red';
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Components.Bearings.Bearing(obj);
           
           K(1,1)=obj.cnfg.mag.k_s+obj.cnfg.mag.k_i*obj.cnfg.mag.Kd;
           K(3,3)=obj.cnfg.mag.k_s+obj.cnfg.mag.k_i*obj.cnfg.mag.Kd;
           
           D(1,1)= obj.cnfg.mag.k_i*obj.cnfg.mag.Kd;
           D(3,3)= obj.cnfg.mag.k_i*obj.cnfg.mag.Kd;
           
           G = zeros(4,4);
           M = zeros(4,4);

        end
        
        function [T] = compute_torque(obj)
        
        end
   end
end