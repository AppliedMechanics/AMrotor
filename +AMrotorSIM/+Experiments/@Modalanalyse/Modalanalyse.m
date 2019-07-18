classdef Modalanalyse < handle
% Modalanalyse Class for modal analysis
%   Calculates the eigenvalues and eigenmodes 
   properties
      name='Modalanalyse'
      % See also AMrotorSIM.Rotorsystem
      rotorsystem@AMrotorSIM.Rotorsystem
      n_ew          % number of desired eigenvalues
      eigenVectors
      eigenValues
   end
   methods
       %Konstruktor
       function obj = Modalanalyse(a)
       % obj = Modalanalyse(rotorsystem)
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
