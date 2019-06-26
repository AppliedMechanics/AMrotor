classdef Force_timevariant_whirl_bwd_sweep < AMrotorSIM.Loads.Load
% Force_timevariant_whirl_bwd_sweep Class of backward whirl with freq-sweep
%   backward whirl with linearly increasing or decreasing frequency
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_whirl_bwd_sweep(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end