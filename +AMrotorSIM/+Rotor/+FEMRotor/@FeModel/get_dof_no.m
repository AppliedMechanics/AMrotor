function dofNo= get_dof_no(rotor,nodeNo)
%GET_DOF_NO
% Get the numbers of all degrees of freedom, that corresponds to the node
% number.

dofPerNode = length(rotor.matrices.M)/length(rotor.mesh.nodes);

dofNo = NaN(length(nodeNo)*dofPerNode,1);

for i = 1:length(nodeNo)
    nodeNoCurr = nodeNo(i);
    dofNo((i-1)*6+1:i*6) = (nodeNoCurr-1)*dofPerNode+1 : nodeNoCurr*dofPerNode;
end

end