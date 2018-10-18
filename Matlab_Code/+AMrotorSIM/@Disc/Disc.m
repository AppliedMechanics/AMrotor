classdef Disc < handle
   properties
      cnfg
      name
      position
      radius
      localisation_matrix
      mass_matrix
      stiffness_matrix
      damping_matrix
      gyroscopic_matrix
      color='yellow'
   end
   methods
       %Konstruktor
       function obj = Disc(arg)
         if nargin == 0
           obj.name = 'Mittelmäßige Massengewichtsscheibe';
         else
           obj.cnfg = arg;
           obj.name = arg.name;
           obj.position = arg.position;
           obj.radius = arg.radius;
         end
       end
           
      function [M,G,D,K] = compute_matrices(obj)
        disp('Compute Matrices Discs')
        M(1,1)=obj.cnfg.m;
        M(2,2)=obj.cnfg.Ix;
        M(3,3)=obj.cnfg.m;
        M(4,4)=obj.cnfg.Ix;             
        
        G(2,4)=-obj.cnfg.Ip;
        G(4,2)=+obj.cnfg.Ip;

       K = zeros(4,4);
       D = zeros(4,4);
      end
    end

    methods

        print(self)
        
        create_ele_loc_matrix(self)
        
        get_loc_mass_matrix(self)
        get_loc_stiffness_matrix(self)
        get_loc_gyroskopic_matrix(self)
      
   end
end