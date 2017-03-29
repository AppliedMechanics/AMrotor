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
%           K = simple_bearing_stiffnes(rotorpar,nodes, obj.cnfg ,moment_of_inertia); 
           K = [obj.cnfg.stiffness,0;0,obj.cnfg.stiffness];
           G = [0,0;0,0];
           M = [0,0;0,0];
           D = [0,0;0,0];
        end
        
        function [T] = compute_torque(obj)
        
        end
        
   end
end