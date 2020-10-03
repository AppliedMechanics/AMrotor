% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Modalanalyse < handle
% Class for modal analysis

%   Calculates the eigenvalues and eigenmodes 
% See also AMrotorSIM.Graphs.Eigenschwingformen
   properties
      name='Modal analysis'
      rotorsystem (1,1) AMrotorSIM.Rotorsystem
      n_ew
      eigenVectors
      eigenValues
   end
   methods
       function obj = Modalanalyse(rotorsystem)
            % Constructor
            %
            %    :parameter rotorsystem: Object of class Rotorsystem
            %    :type rotorsystem: object
            %    :return: Modal analysis object
            
       % obj = Modalanalyse(a)
         if nargin == 0
           disp('No Modal analysis possible without Rotorsystem')
         else
           obj.rotorsystem = rotorsystem;
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
