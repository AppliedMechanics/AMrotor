classdef TwoWayLager < AMrotorSIM.Bearings.Lager
   properties
       cnfg
   end
   methods
        function obj=TwoWayLager(arg) 
           obj = obj@AMrotorSIM.Bearings.Lager(arg);
           obj.cnfg = arg;
           obj.color = 'magenta';
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Bearings.Lager(obj);
           
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