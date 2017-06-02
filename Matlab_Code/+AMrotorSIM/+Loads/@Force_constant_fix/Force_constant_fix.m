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
        end
        
   end
end