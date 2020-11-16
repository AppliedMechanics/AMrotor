function VMassNormalized = do_mass_normalization(obj,V,M)
% Performs mass normalization of the modes, so that transpose(V)*M*V=1
%
%    :param V: Eigenvectors columnwise
%    :type V: matrix
%    :param M: Mass
%    :type M: matrix
%    :return: Normalized eigenvector matrix V

% Licensed under GPL-3.0-or-later, check attached LICENSE file

modalMasses = diag(transpose(V)*M*V);
tmp = 1./sqrt(modalMasses);
VMassNormalized = V*diag(tmp);
end