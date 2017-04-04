classdef Force_constant_fix < AMrotorSIM.Loads.Load
   properties
   end
   methods
       %Konstruktor
        function obj=Force_constant_fix(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
       
        function compute_load(obj)
            % Positionen in Gesamtvektor
            
            Fx = obj.cnfg.betrag_x;
            Fy = obj.cnfg.betrag_y;
            
            obj.h.h(1) =  Fx;
            obj.h.h(3) =  Fy;
            
            obj.h.h_ZPcos(1) = 0;
            obj.h.h_ZPcos(3) = 0;
            obj.h.h_ZPsin(1) = 0;
            obj.h.h_ZPsin(3) = 0;

            obj.h.h_DBcos(1) = 0;
            obj.h.h_DBcos(3) = 0;
            obj.h.h_DBsin(1) = 0;
            obj.h.h_DBsin(3) = 0; 

        end
        
   end
end