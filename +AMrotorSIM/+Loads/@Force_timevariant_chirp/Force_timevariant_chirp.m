classdef Force_timevariant_chirp < AMrotorSIM.Loads.Load
% Force_timevariant_chirp Class of force-chirp
%   increasing or decreasing excitation frequency
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_chirp(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end