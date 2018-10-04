classdef (Abstract) Seal < matlab.mixin.Heterogeneous & handle
   properties
      name
      position
      type
      localisation_matrix
      mass_matrix
      stiffness_matrix
      damping_matrix
      color='black'
%       sealModel
   end
   methods
      %Konstruktor
       function obj = Seal(arg)
         if nargin == 0
           obj.name = 'starke Dichtung!';
         else
           obj.name = arg.name;
           obj.position=arg.position;
           obj.type = arg.type;
         end
       end
      
   end
   
      methods(Abstract)
         
        print(self)
        
        create_ele_loc_matrix(self)
        
        get_loc_mass_matrix(self)
        get_loc_stiffness_matrix(self)
        get_loc_damping_matrix(self)
        
      end

end