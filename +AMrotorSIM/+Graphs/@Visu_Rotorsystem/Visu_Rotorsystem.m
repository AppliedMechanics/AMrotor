classdef Visu_Rotorsystem < handle
% Visu_Rotorsystem Class for visualisation of the rotor system
   properties
      name='Rotor Gesamtsystem'
      % See also AMrotorSIM.Rotorsystem
      rotorsystem
   end
   methods
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
         plot_components(figurehandle,obj.rotorsystem.components,obj.rotorsystem.rotor);
         plot_sensors(figurehandle,obj.rotorsystem.sensors);
         plot_loads(figurehandle,obj.rotorsystem.loads,obj.rotorsystem.rotor);
         plot_pidController(figurehandle,obj.rotorsystem.pidControllers,obj.rotorsystem.rotor);
         view(3)
         
      end
 
   end
   methods(Access=private)
       
   end
end