% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Visu_Rotorsystem < handle
% Class for visualization of the rotor system

   properties
      name='Rotor system'
      rotorsystem
   end
   methods
       function obj = Visu_Rotorsystem(rotorsystem)
       % Constructor
       %
       %    :parameter rotorsystem: Object of type Rotorsystem
       %    :type rotorsystem: object
       %    :return: Object of type Visu_Rotorsystem
       
         if nargin == 0
           disp('No geometry available without Rotorsystem')
         else
           obj.rotorsystem = rotorsystem;
         end
       end
   end
   methods(Access=private)
       
   end
end