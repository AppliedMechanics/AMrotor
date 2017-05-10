classdef Newmark < AMrotorSIM.Solvers.Solver
   properties
   end
   methods
      %Konstruktor
       function obj = Newmark()
         if nargin == 0
         else
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
   end
end