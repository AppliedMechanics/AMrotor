classdef Load < matlab.mixin.Heterogeneous & handle
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
           obj.name = 'Unkontrollierte Last';
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

    get_loc_load_vec(self)
    get_loc_timeload_vec(self,time)

  end
end