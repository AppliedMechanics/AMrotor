classdef PID_MagneticBearing < AMrotorSIM.Bearings.Lager
   properties
        cnfg
        x_w = [0,0]
        xd_w = [0,0]
   end
   methods
        function obj=PID_MagneticBearing(arg) 
           obj = obj@AMrotorSIM.Bearings.Lager(arg);
           obj.cnfg = arg; 
        end 
        
        function [M,G,D,K] = compute_matrices(obj)
         compute_matrices@AMrotorSIM.Bearings.Lager(obj);
           
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
   methods  
        [ss_out] = add_controller_ss(obj,ss_in,dir,rotorsystem)
        [Fx,Fy]= compute_force(obj, x,y,Ix,Iy)
   end
end