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
        
        function [F]= compute_force(obj, x,xd,xdd,dtspan)
            
            %Reglerkonstanten aus Config-Datei
            Kp=obj.cnfg.mag.Kp;
            Kd=obj.cnfg.mag.Kd;
            Ki=obj.cnfg.mag.Ki;
            
            %Magnetlagerkonstanten aus Config-Datei
            k_i=obj.cnfg.mag.k_i;
            k_s=obj.cnfg.mag.k_s;

            
            err = obj.x_w-x; %Fehler = Sollgröße - Istgröße
            d_err = obj.xd_w - xd;
            dd_err = obj.xdd_w - xdd;

            
            %Regler
            %init_con = [yold ; (yold-yold1)]; 
            init_con = [0;0];
            options = [];
            [t,I]  = ode45(@pid_ctrl,dtspan,init_con,options,err,d_err,dd_err, Kp,Ki,Kd); 

            %Kraftbestimmung
            F=[k_i*I(1) + k_s*x(1),k_i*I(2) + k_s*x(2)];
         
        end
            
        function [T] = compute_torque(obj)
        end
   end
end