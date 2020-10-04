% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Visu_Rotorgeometrie < handle
% Visu_Rotorgeometrie Class for visualisation of the rotor geomety
   properties
      name='Rotor geometry'
      rotor = AMrotorSIM.Rotor().empty
   end
   methods
       function obj = Visu_Rotorgeometrie(rotorsystem)
            % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :return: Object for Rotorgeometry
            
         if nargin == 0
           disp('No geometry available without Rotorsystem')
         else
           obj.rotor = rotorsystem;
         end
       end
      
      function show(obj)
          % Displays the object name in the Command Window and carries out the plot of the geometry
          %
          %    :return: Notification of the object name and figure of the rotor
          
         disp(obj.name);
         plot_rotor_geometry(obj.rotor);
      end
 
   end
   methods(Access=private)
       
   end
end