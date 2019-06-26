classdef Force_constant_fix < AMrotorSIM.Loads.Load
% Force_constant_fix Class of force with constant amplitude and direction
   properties
   end
   methods
       %Konstruktor
        function obj=Force_constant_fix(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end