classdef Orbit < handle
   properties
      name
      rotorsystem
   end
   methods
       %Konstruktor
       function obj = Orbit(a)
         if nargin == 0
           disp('Keine Orbitdarstellung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.name = strcat(obj.rotorsystem.name,'- Wegorbits');
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end