classdef Force_timevariant_LUT < AMrotorSIM.Loads.Load
% Force_timevariant_LUT Class of force from Look Up table
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_LUT(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable);
        end 
        
   end
end