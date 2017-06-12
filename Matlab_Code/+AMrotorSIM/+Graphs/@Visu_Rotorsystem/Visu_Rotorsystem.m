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
         plot_bearings(figurehandle,obj.rotorsystem.lager,obj.rotorsystem.rotor);
         plot_sensors(figurehandle,obj.rotorsystem.sensors);
         plot_loads(figurehandle,obj.rotorsystem.loads);
         
         %view (180,0)
         %camroll (-90)
         
%          xx = get(figurehandle, 'xData');
%          zz = get(figurehandle, 'zData');
%          set(figurehandle, 'xData', zz 'zData', xx);
         
      end
 
   end
   methods(Access=private)
       
   end
end