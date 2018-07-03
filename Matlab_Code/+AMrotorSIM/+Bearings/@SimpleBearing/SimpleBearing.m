classdef SimpleBearing < AMrotorSIM.Bearings.Bearing
   properties
       cnfg
   end
   methods
        function obj=SimpleBearing(arg) 
           obj = obj@AMrotorSIM.Bearings.Bearing(arg);
           obj.cnfg = arg;
           obj.color = 'green';
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Bearings.Bearing(obj);
           
           K(1,1)=obj.cnfg.stiffness;
           K(3,3)=obj.cnfg.stiffness;
           
           G = zeros(4,4);
           M = zeros(4,4);
           D = zeros(4,4);
        end
        
        function [T] = compute_torque(obj)
        
        end
        
   end
end