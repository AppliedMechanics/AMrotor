classdef Force_timevariant_whirl_fwd_sweep < AMrotorSIM.Loads.Load
% Force_timevariant_whirl_fwd_sweep Class of forward whirl with freq-sweep
%   forward whirl with linearly increasing or decreasing frequency
   properties
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_whirl_fwd_sweep(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end