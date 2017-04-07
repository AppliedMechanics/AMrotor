classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem
      
      n_ew
      eigenmatrizen
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

      function calculate_rotor_only(obj,n_modes)
          
          obj.n_ew = n_modes;
          
          K=obj.rotorsystem.rotor.matrizen.K;
          M=obj.rotorsystem.rotor.matrizen.M;
          
         [obj.eigenmatrizen.EVmr,EWmr]=eigs(K,M,n_modes,'sm');
      end
      
      function plot(obj)
          

      end
 
   end
   methods(Access=private)
       
   end
end