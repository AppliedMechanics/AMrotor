classdef Modalanalyse < handle
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
       
   end
   methods(Access=private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function declarations; definitions are in the 'private' folder
        [A,B] = get_state_space_matrices(obj,omega)
        [M,D,K] = add_seal_matrices(obj,rpm)
        [V,D] = perform_eigenanalysis(obj,mat)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   end
end
