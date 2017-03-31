classdef SimpleLager < Lager
   properties
       cnfg
   end
   methods
        function obj=SimpleLager(arg) 
           obj = obj@Lager(arg);
           obj.cnfg = arg;
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@Lager(obj);
           
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