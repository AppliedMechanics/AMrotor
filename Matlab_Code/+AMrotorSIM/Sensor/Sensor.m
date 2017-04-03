classdef Sensor < matlab.mixin.Heterogeneous
   properties
      name
      position
      direction
   end
   methods
      %Konstruktor
       function obj = Sensor(arg)
         if nargin == 0
           obj.name = "Depp";
         else
           obj.name = arg.name;
           obj.position=arg.position;
         end
        addpath(strcat(fileparts(which(mfilename)),'\fcns'));
      end
      
      function print(obj)
         disp(obj.name);
      end
   end
end