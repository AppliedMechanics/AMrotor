classdef Lager < handle
   properties
      name
      position
   end
   methods
      %Konstruktor
       function obj = Lager(arg)
         if nargin == 0
           obj.name = "starkes Lager!";
         else
           obj.name = arg.name;
           obj.position=arg.position;
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
   end
end