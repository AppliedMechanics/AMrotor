% Licensed under GPL-3.0-or-later, check attached LICENSE file

function Vpos = get_position_entries(obj,V)
% Extracts ???????????????????
%
%    :param V: Eigenvectors columnwise
%    :type V: matrix
%    :return: Eigenvectormatrix relative to position

    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    ind = n.nodes*2*2+1:n.nodes*2*4;
    Vpos = V(ind,:);
end