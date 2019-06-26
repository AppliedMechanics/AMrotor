classdef Force_timevariant_whirl_fwd < AMrotorSIM.Loads.Load
% Force_timevariant_whirl_fwd Class of forward whirl with const frequnency
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_whirl_fwd(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end