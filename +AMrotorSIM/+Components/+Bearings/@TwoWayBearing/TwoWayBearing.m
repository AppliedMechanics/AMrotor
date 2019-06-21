classdef TwoWayBearing < AMrotorSIM.Components.Bearings.Bearing
   properties
       cnfg
   end
   methods
        function obj=TwoWayBearing(arg) 
           obj = obj@AMrotorSIM.Components.Bearings.Bearing(arg);
           obj.cnfg = arg;
           obj.color = 'magenta';
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Components.Bearings.Bearing(obj);
           
           K(1,1)=obj.cnfg.stiffness.x;
           K(3,3)=obj.cnfg.stiffness.y;
           
           G = zeros(4,4);
           M = zeros(4,4);
           D = zeros(4,4);
        end
        
        function [T] = compute_torque(obj)
        
        end
        
   end
end