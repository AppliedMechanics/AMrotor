function [G] = assemble_gyroscopic_matrix(self)
% Assembles gyroscopic matrix 
%
%    :return: Gyroscopic matrix G

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    % According to Genta 2005: Dynamics of Rotating Systems

   
    [GAB,GBA] = compute_gyroscopic_matrix(self);
    % results GAB and GBA in q_A and q_B
    % q_A = [u_x1; psi_y1; u_x2; psi_y2] (bending in x-z-plane)
	% q_B = [u_y1; psi_x1; u_y2; psi_x2] (bending in y-z-plane)

    G = zeros(12,12);
    

    G(5:8,9:12) = GAB;
    G(9:12,5:8) = GBA;
    % element dofs:
    % q = [u_x1; u_y1; u_z1; psi_x1; psi_y1; psi_z1; ...
    %   u_x2; u_y2; u_z2; psi_x2; psi_y2; psi_z2 ]

    self.gyroscopic_matrix = G;
end