classdef Visu_Esf < handle
   properties
      name='Rotor Eigenschwingformen'
      rotor = Rotor().empty
   end
   methods
       %Konstruktor
       function obj = Visu_Esf(a)
         if nargin == 0
           disp('Kein Visualierung möglich ohne Rotorsystem')
         else
           obj.rotor = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
%         plot_EV_EW(obj.rotor);
      end
 
   end
   methods(Access=private)
       
   end
end