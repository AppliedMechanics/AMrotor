classdef Hochlaufanalyse < handle
   properties
      name='Hochlaufanalyse'
      rotorsystem = Rotorsystem().empty
      drehzahl
   end
   methods
       %Konstruktor
       function obj = Hochlaufanalyse(a,drehzahlen)
         if nargin == 0
           disp('Keine Modalanalyse möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahl = drehzahlen;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end