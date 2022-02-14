function [G] = assemble_gyroscopic_matrix(self)
% Assembles gyroscopic matrix 
%
%    :return: Gyroscopic matrix G

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   
    [G1,G2] = compute_gyroscopic_matrix(self);

    G = zeros(12,12);
    

    G(5:8,9:12) = G1;
    G(9:12,5:8) = G2;

    self.gyroscopic_matrix = G;
end