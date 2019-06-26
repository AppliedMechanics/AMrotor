classdef Modalanalyse < handle
% Modalanalyse Class for modal analysis
%   Calculates the eigenvalues and eigenmodes 
   properties
      name='Modalanalyse'
      rotorsystem
      eigenmatrizen
      n_ew
      eigenVectors
      eigenValues
   end
   methods
       %Konstruktor
       function obj = Modalanalyse(a)
         if nargin == 0
           disp('Keine Modalanalyse möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
       
       function [num] = get_number_of_eigenvalues(obj)
            num.all = length(obj.eigenValues.lateral);
        end
       
   end
   methods(Access=private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function declarations; definitions are in the 'private' folder
        [A,B] = get_state_space_matrices(obj,omega)
        [V,D] = perform_eigenanalysis(obj,mat)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   end
end
