classdef Load < matlab.mixin.Heterogeneous & handle
% Superclass (abstract) for all loads (forces) on the rotor system

%   loads are computed on the right-hand side of the system's equations:
%   M*xdd+D*xd+K*x=Loads
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
    name
    cnfg=struct([]) 
    position
    type
    h
    localisation_matrix
   end
   methods
       function self = Load(arg)
           % Constructor
         if nargin == 0
           self.name = 'Empty Load';
         else
           self.cnfg = arg;
           self.name = self.cnfg.name;
           self.position=self.cnfg.position;
           self.type = self.cnfg.type;
         end            
       end
        
   end
   
   methods(Abstract)

    print(self)

    create_ele_loc_matrix(self)

    get_loc_load_vec(self,time,node)

  end
end