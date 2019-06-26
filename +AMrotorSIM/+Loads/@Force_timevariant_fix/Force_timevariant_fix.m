classdef Force_timevariant_fix < AMrotorSIM.Loads.Load
% Force_timevariant_fix Class for sine-force with constant frequency
properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_fix(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end