classdef Load < matlab.mixin.Heterogeneous & handle
% Load Class for the forces on the rotor system
%   loads are computed on the right-hand side of the system's equations:
%   M*xdd+D*xd+K*x=Loads
   properties
      cnfg=struct([])    
      name
      h
      localisation_matrix
      position
   end
   methods
       %Konstruktor
       function obj = Load(a)
         if nargin == 0
           obj.name = 'Empty Load';
         else
           obj.cnfg = a;
           obj.name = obj.cnfg.name;
           obj.position=obj.cnfg.position;
         end            
       end
        
   end
   
   methods(Abstract)

    print(self)

    create_ele_loc_matrix(self)

    get_loc_load_vec(self,time,node)

  end
end