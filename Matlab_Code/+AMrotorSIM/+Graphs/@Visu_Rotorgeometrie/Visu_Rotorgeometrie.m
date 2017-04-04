classdef Visu_Rotorgeometrie < handle
   properties
      name='Rotor Geometrie'
      rotor = AMrotorSIM.Rotor().empty
   end
   methods
       %Konstruktor
       function obj = Visu_Rotorgeometrie(a)
         if nargin == 0
           disp('Kein Geometrieanzeige m�glich ohne Rotorsystem')
         else
           obj.rotor = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
         plot_rotor_geometry(obj.rotor);
      end
 
   end
   methods(Access=private)
       
   end
end