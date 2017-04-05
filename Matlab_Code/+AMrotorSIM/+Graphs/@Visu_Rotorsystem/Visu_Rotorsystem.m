classdef Visu_Rotorsystem < handle
   properties
      name='Rotor Gesamtsystem'
      rotorsystem
   end
   methods
       %Konstruktor
       function obj = Visu_Rotorsystem(a)
         if nargin == 0
           disp('Kein Geometrieanzeige möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
         figurehandle=plot_rotor(obj.rotorsystem.rotor);
         plot_discs(figurehandle,obj.rotorsystem.discs);
         plot_bearings(figurehandle,obj.rotorsystem.lager);
      end
 
   end
   methods(Access=private)
       
   end
end