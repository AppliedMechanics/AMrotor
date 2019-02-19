classdef Force_timevariant_look_up < AMrotorSIM.Loads.Load
   properties
       Table
   end
   methods
       %Konstruktor
        function obj=Force_timevariant_look_up(variable) 
           obj = obj@AMrotorSIM.Loads.Load(variable); 
           obj.Table = variable.Table;
        end 
        
   end
end