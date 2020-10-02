% Licensed under GPL-3.0-or-later, check attached LICENSE file

function check_selected_dof(obj,inputDirection,outputDirection)
% Checks if only translational DoFs are used???????????
%
%    :param inputDirection: Input direction
%    :type inputDirection: double
%    :param outputDirection: Output direction
%    :type outputDirection: double
%    :return: If necessary, error message

allowedInputDofs = [1,2,3];
allowedOutputDofs = allowedInputDofs;
flagDimInput = length(inputDirection)~=1;
flagDimOutput = length(outputDirection)~=1;
flagInput = all(inputDirection ~= allowedInputDofs);
flagOutput = all(outputDirection ~= allowedOutputDofs);

if flagDimInput
    error('Input size is larger than 1')
end

if flagDimOutput
    error('Output size is larger than 1')
end

if flagInput||flagOutput
    
    dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
    dof_loc = [1,2,3,4,5,6];
    strDof = containers.Map(dof_loc,dof_name);
    
    allowedInputDofsStr = [];
    for i=1:length(allowedInputDofs)
        allowedInputDofsStr = [allowedInputDofsStr,' ',strDof(allowedInputDofs(i))];
    end
    
    allowedOutputDofsStr = [];
    for i=1:length(allowedOutputDofs)
        allowedOutputDofsStr = [allowedOutputDofsStr,' ',strDof(allowedOutputDofs(i))];
    end
    
    
    if flagInput
        error(['Only input dofs',allowedInputDofsStr,' allowed'])
    end
    
    if flagOutput
        error(['Only output dofs',allowedOutputDofsStr,' allowed'])
    
    end
end

end