classdef MagnetLager < Lager
   properties
       Steifigkeit
   end
   methods
        function obj=MagnetLager(variable) 
           obj = obj@Lager(variable); 
        end 
   end
end