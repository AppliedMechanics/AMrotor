classdef Campbell < handle
   properties
      name='Campbell Diagramm'
      rotor = Rotor().empty
   end
   methods
       %Konstruktor
       function obj = Campbell(a)
         if nargin == 0
           disp('Keine Modalanalyse möglich ohne Rotorsystem')
         else
           obj.rotor = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end