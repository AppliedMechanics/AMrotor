classdef Solver < matlab.mixin.Heterogeneous & matlab.System & handle
   properties
      cnfg=struct([])  
      name
   end
   methods
      %Konstruktor
       function obj = Solver(arg)
         if nargin == 0
         else
           obj.cnfg = arg;
           obj.name = obj.cnfg.name;
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
   end
end