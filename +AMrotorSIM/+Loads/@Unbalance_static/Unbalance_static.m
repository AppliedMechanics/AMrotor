classdef Unbalance_static < AMrotorSIM.Loads.Load
% Unbalance_static Class for force of unbalance on the rotor
   properties

   end
   methods
       %Konstruktor
        function obj=Unbalance_static(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end