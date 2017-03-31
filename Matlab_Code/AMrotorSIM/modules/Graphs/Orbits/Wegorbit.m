classdef Wegorbit < Orbit
   properties
    unit = "m"
   end
   methods
      function obj=Wegorbit(variable) 
           obj = obj@Orbit(variable); 
      end 
   end
end