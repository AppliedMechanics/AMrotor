classdef Wegorbit < AMrotorSIM.Graphs.Orbit
   properties
    unit = 'm'
   end
   methods
      function obj=Wegorbit(variable) 
           obj = obj@AMrotorSIM.Graphs.Orbit(variable); 
      end
     
   end
end