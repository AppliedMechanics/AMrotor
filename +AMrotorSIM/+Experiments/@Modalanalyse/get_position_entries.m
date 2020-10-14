% Licensed under GPL-3.0-or-later, check attached LICENSE file

function Vpos = get_position_entries(obj,V,mat)
% Extracts the elements of the eigenvector matrix referring to the position
%
%    :param V: Eigenvectors columnwise
%    :type V: matrix
%    :param mat: State space matrices A,B (mat.A,mat.B)
%    :type mat: struct
%    :return: Eigenvectormatrix with only position entries

    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.dofPerNode = length(mat.A)/n.nodes/2;
    ind = n.nodes*n.dofPerNode+1:n.nodes*2*n.dofPerNode;
    Vpos = V(ind,:);
end