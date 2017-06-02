classdef Disc < handle
   properties
      cnfg=struct([])
      
      name
   end
   methods
       %Konstruktor
       function obj = Disc(a)
         if nargin == 0
           obj.name = 'Mittelmäßige Massengewichtsscheibe';
         else
           obj.cnfg = a;
           obj.name = obj.cnfg.name;
         end
       end
      
      function print(obj)
         disp(obj.name);
      end
      
      function [M,G,D,K] = compute_matrices(obj)
        
        M(1,1)=obj.cnfg.m;
        M(2,2)=obj.cnfg.Ix;
        M(3,3)=obj.cnfg.m;
        M(4,4)=obj.cnfg.Ix;             
        
        G(2,4)=-obj.cnfg.Iz;
        G(4,2)=+obj.cnfg.Iz;

       K = zeros(4,4);
       D = zeros(4,4);
      end
      
      function visu(obj)
         disp('Start visualization');
      end 
      
   end
end