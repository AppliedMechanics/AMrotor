classdef Kraefte < handle
   properties
      name
      rotorsystem
   end
   methods
       %Konstruktor
       function self = Kraefte(a)
         if nargin == 0
           disp('Keine Kraftdarsellung möglich ohne Rotorsystem und Sensoren')
         else
           self.rotorsystem = a;
           self.name = strcat(self.rotorsystem.name,'- Lagerkräfte');
         end
       end
      
      function show(self)
         disp(self.name);
      end
 
   end
   methods(Access=private)
       
   end
end

