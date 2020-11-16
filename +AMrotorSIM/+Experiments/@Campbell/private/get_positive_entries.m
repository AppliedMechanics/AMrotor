function [Vout, Dout] = get_positive_entries(Vin,Din)
% Extracts only the positive enries of V and D
%
%    :param Vin: Eigenvectormatrix raw
%    :type Vin: matrix
%    :param Din: Eigenvaluematrix (diagonal) raw
%    :type Din: matrix
%    :return: V and D with only positive entries

% Licensed under GPL-3.0-or-later, check attached LICENSE file

Dout = Din(imag(Din)>0);
Vout = Vin(:,imag(Din)>0);
end

