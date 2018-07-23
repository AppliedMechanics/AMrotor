classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem
      eigenmatrizen
      n_ew
      eigenVectors
      eigenValues
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
       
   end
   methods(Access=private)
       
   end
end
