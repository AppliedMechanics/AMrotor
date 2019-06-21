function dofNo= get_dof_no(rotor,nodeNo)
%GET_DOF_NO 
% Get the numbers of all degrees of freedom, that corresponds to the node
% number.

dofPerNode = length(rotor.matrices.M)/length(rotor.mesh.nodes);

dofNo = (nodeNo-1)*dofPerNode+1 : nodeNo*dofPerNode;
end

