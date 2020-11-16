classdef Solver < matlab.mixin.Heterogeneous & handle
    % Superclass (abstract) for solvers
    
    % Licensed under GPL-3.0-or-later, check attached LICENSE file
    
   properties
      cnfg=struct([])  
      name
   end
   methods

       function obj = Solver(arg)
           % Constructor
         if nargin == 0
         else
           obj.cnfg = arg;
           obj.name = obj.cnfg.name;
         end
      end
      
      function print(obj)
          % Displays the object name in the Command Window
          %
          %    :return: Notification of object name
         disp(obj.name);
      end
   end
end