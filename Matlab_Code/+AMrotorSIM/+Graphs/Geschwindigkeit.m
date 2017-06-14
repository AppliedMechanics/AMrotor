classdef Geschwindigkeit < handle
   properties
      name
      rotorsystem
   end
   methods
       %Konstruktor
       function self = Geschwindigkeit(a)
         if nargin == 0
           disp('Keine Geschwindigkeitsdarstellung möglich ohne Rotorsystem')
         else
           self.rotorsystem = a;
           self.name = strcat(self.rotorsystem.name,'- Geschwindigkeiten');
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end

