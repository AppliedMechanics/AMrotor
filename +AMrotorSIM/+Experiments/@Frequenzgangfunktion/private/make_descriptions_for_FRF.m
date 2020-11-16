function descriptionsH = make_descriptions_for_FRF(obj,inputNode,outputNode,inputDirection,outputDirection)
% Assigns a description of the FRF's regarding the position and the orientation of the in- and outputs of the FRF's
%
%    :param inputNode: Node number\numbers of the input 
%    :type inputNode: vector(double)
%    :param outputNode: Node number\numbers of the output 
%    :type outputNode: vector(double)
%    :param inputDirection: Desired input direction from 1 to 6 (e.g. 'u_x' -> 1, 'psi_y' -> 5)
%    :type inputDirection: double
%    :param outputDirection: Desired output direction from 1 to 6 (e.g. 'u_x' -> 1, 'psi_y' -> 5)
%    :type outputDirection: double
%    :return: Added description parameter (cell) to the object

% Licensed under GPL-3.0-or-later, check attached LICENSE file
            
dof_name = {'X','Y','Z','PSIX','PSIY','PSIZ'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_loc,dof_name);

nDofsTotalIn = length(inputNode) * length(inputDirection);
nDofsTotalOut = length(outputNode) * length(outputDirection);
descriptionsH = cell( nDofsTotalOut, nDofsTotalIn);

iIn=0;iOut=0;
for iOutNode = 1 : length(outputNode)
    for iOutDir = 1 : length(outputDirection)
        iOut = iOut + 1;
        iIn = 0;
        for iInNode = 1 : length(inputNode)
            for iInDir = 1 : length(inputDirection)
                iIn = iIn + 1;
                
                
                currInputDirection = inputDirection(iInDir);
                currOutputDirection = outputDirection(iOutDir);
                currInputNode = inputNode(iInNode);
                currOutputNode = outputNode(iOutNode);
                inPosStr = num2str( obj.rotorsystem.rotor.mesh.nodes(currInputNode).z*1e3 , '%3.0f' );
                inDirStr = ldof(currInputDirection);
                
                outPosStr = num2str( obj.rotorsystem.rotor.mesh.nodes(currOutputNode).z*1e3 , '%3.0f' );
                outDirStr = ldof(currOutputDirection);
                
                descriptionsH{iOut,iIn} = ['in',inPosStr,inDirStr,' out',outPosStr,outDirStr];
                
            end
        end
    end
end

obj.descriptionsH = descriptionsH;
end