classdef Load < matlab.mixin.Heterogeneous & handle
   properties
      cnfg=struct([])    
      name
      h
   end
   methods
       %Konstruktor
       function obj = Load(a)
         if nargin == 0
           obj.name = "Unkontrollierte Last";
         else
           obj.cnfg = a;
           obj.name = obj.cnfg.name;
         end
       end
       
      function print(obj)
         disp(obj.name);
      end
        
   end
end