classdef Orbit < handle
   properties
      name
      rotorsystem = Rotorsystem().empty
   end
   methods
       %Konstruktor
       function obj = Wegorbit(a)
         if nargin == 0
           disp('Keine Orbitdarstellung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.name = obj.rotorsystem.lager
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end