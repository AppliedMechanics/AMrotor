classdef PID_MagneticBearing < AMrotorSIM.Bearings.Lager
   properties
        cnfg
        ss_position
   end
   methods
        function obj=PID_MagneticBearing(arg) 
           obj = obj@AMrotorSIM.Bearings.Lager(arg);
           obj.cnfg = arg; 
           
           obj.color = 'yellow';
           
           obj.ss_position.n_x = 0;
           obj.ss_position.n_y = 0;
           obj.ss_position.n_Ix = 0;
           obj.ss_position.n_Iy = 0;
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Bearings.Lager(obj);
           
           K = zeros(4,4);
           D = zeros(4,4);
           G = zeros(4,4);
           M = zeros(4,4);
        end
            
        function [T] = compute_torque(obj)
        end
   end
   methods  
        [ss_out] = add_controller_ss(obj,ss_in,dir,rotorsystem)
        [Fx,Fy]= compute_force(obj, x,y,Ix,Iy)
   end
end