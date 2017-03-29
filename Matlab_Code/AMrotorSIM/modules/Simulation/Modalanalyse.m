classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem = Rotorsystem().empty
      eigen=struct.empty
   end
   methods
       %Konstruktor
       function obj = Modalanalyse(a)
         if nargin == 0
           disp('Keine Modalanalyse möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end

      function calculate_ew_ev(obj)
          
      end
 
   end
   methods(Access=private)
       
   end
end