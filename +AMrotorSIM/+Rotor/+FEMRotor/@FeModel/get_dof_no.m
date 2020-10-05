% Licensed under GPL-3.0-or-later, check attached LICENSE file

function dofNo= get_dof_no(rotor,nodeNo)
% Get the numbers of all degrees of freedom, that correspond to the node numbers. necessary?????
%
%    :parameter rotor: Object of type rotorsystem ????
%    :type rotor: object
%    :parameter nodeNo: Number of the desired node
%    :type nodeNo: double
%    :return: Global DoF 

%GET_DOF_NO - get the dofs of selected nodes
% dofNo= get_dof_no(rotor,nodeNo)


dofPerNode = length(rotor.mass_matrix)/length(rotor.mesh.nodes);

dofNo = NaN(length(nodeNo)*dofPerNode,1);

for i = 1:length(nodeNo)
    nodeNoCurr = nodeNo(i);
    dofNo((i-1)*6+1:i*6) = (nodeNoCurr-1)*dofPerNode+1 : nodeNoCurr*dofPerNode;
end

end