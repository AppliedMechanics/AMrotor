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
      
      function [figurehandle] = show(obj)
         disp(obj.name);
         figurehandle=obj.rotorsystem.rotor.mesh.show_3D;
         plot_discs(figurehandle,obj.rotorsystem.discs);
         plot_bearings(figurehandle,obj.rotorsystem.bearings,obj.rotorsystem.rotor);
         plot_sensors(figurehandle,obj.rotorsystem.sensors);
         plot_loads(figurehandle,obj.rotorsystem.loads,obj.rotorsystem.rotor);
         plot_seals(figurehandle,obj.rotorsystem.seals,obj.rotorsystem.rotor);
         
         view(3)%view(126,35)
         
         
%          xx = get(figurehandle, 'xData');
%          zz = get(figurehandle, 'zData');
%          set(figurehandle, 'xData', zz 'zData', xx);
         
      end
 
   end
   methods(Access=private)
       
   end
end