classdef Load < matlab.mixin.Heterogeneous & handle
   properties
      cnfg=struct([])    
      name
      h
   end
   methods
       %Konstruktor
       function obj = Load(a)
         if nargin == 0
           obj.name = 'Unkontrollierte Last';
         else
           obj.cnfg = a;
           obj.name = obj.cnfg.name;
         end
            %Constant fix force 
            obj.h.h(1:4) = 0;
                    
            %centripetal-force unbalance, rotating
            obj.h.h_ZPcos(1:4) = 0;
            obj.h.h_ZPsin(1:4) = 0;

            %unbalance mass inertia force 
            obj.h.h_DBcos(1:4) = 0;
            obj.h.h_DBsin(1:4) = 0;
            
            %Constant_fix_force in rotor coordinates!
            obj.h.h_sin(1:4) = 0;                     
            obj.h.h_cos(1:4) = 0;

            %rotating_fix_force%   e.g  bearing exitation 
            obj.h.h_rotsin(1:4) = 0;                   
            obj.h.h_rotcos(1:4) = 0;
       end
       
      function print(obj)
         disp(obj.name);
      end
        
   end
end