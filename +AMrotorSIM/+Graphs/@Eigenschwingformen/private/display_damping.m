% Licensed under GPL-3.0-or-later, check attached LICENSE file

function display_damping( strCoordinate, eigenvalue )
% Displays the damping ratios (only approximately correct for small damping ratios) in the Command Window
%
%    :param strCoordinate: Description of the damping
%    :type strCoordinate: char
%    :param eigenvalue: EV's from the modal analysis
%    :type eigenvalue: complex double
%    :return: Notification of the modal damping (D= -real(lambda)/imag(lambda))

% This is only approximately correct for small damping ratios
% Here the damping ratio is calculated by D_here=delta/omega_d from eigenvalues
% lambda=-delta+1i*omega_d. 
% The correct calculation would use D_corr=delta/omega_0
% D_here = D_corr/sqrt(1-D_corr^2) = delta/omega_d -> only correct for
% small damping (D<<1)
%
% to obatin correct values, one would need the system matrices M,D,K and
% the eigenvectors U:
% K_modal = transpose(U)*K*U;
% D_modal = transpose(U)*D*U;
% M_modal = transpose(U)*M*U; (Diagonal matrices) (really?, because multiple eigenvalues for symmetric rotor, also D not diagonal if non-modal damping)
% k_modal = diag(K_modal);
% d_modal = diag(D_modal);
% m_modal = diag(M_modal);
% omega_0 = sqrt(k_modal/m_modal);
% D = delta/omega_0;

delta = -real(eigenvalue);
omegad = imag(eigenvalue);

D = delta/omegad; % Lehr damping
disp([strCoordinate,'  ',num2str(D*100),' % modal damping [approximation -real(lambda)/imag(lambda)]'])

end

