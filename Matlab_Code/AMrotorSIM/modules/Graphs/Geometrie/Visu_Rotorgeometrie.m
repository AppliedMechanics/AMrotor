classdef Visu_Rotorgeometrie < handle
   properties
      name='Rotor Geometrie'
      rotor = Rotor().empty
   end
   methods
       %Konstruktor
       function obj = Visu_Rotorgeometrie(a)
         if nargin == 0
           disp('Kein Geometrieanzeige möglich ohne Rotorsystem')
         else
           obj.rotor = a;
         end
        addpath(strcat(fileparts(which(mfilename)),'\fcns'));
       end
      
      function show(obj)
         disp(obj.name);
         plot_rotor_geometry(obj.rotor);
      end
 
   end
   methods(Access=private)
       
   end
end