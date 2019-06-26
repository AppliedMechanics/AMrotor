classdef Force_timevariant_whirl_bwd < AMrotorSIM.Loads.Load
% Force_timevariant_whirl_bwd Class of backward whirl with const frequnency
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_whirl_bwd(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end