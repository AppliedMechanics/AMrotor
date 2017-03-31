classdef Load < matlab.mixin.Heterogeneous
   properties
      cnfg=struct([])    
      name
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
         addpath(strcat(fileparts(which(mfilename)),'\fcns'));
       end
       
      function print(obj)
         disp(obj.name);
      end
        
   end
end