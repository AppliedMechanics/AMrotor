function descriptionsH = make_descriptions_for_FRF(obj)
% Assigns a description of the FRF's regarding the position and the orientation of the in- and outputs of the FRF's
%
%    :return: Added description parameter to the object

% Licensed under GPL-3.0-or-later, check attached LICENSE file

sensorIn = obj.sensorIn;
sensorOut = obj.sensorOut;
inputDirection = obj.inputDirection;
outputDirection = obj.outputDirection;

dof_name = {'X','Y','Z','PSIX','PSIY','PSIZ'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_loc,dof_name);

nDofsTotalIn = length(inputDirection);
nDofsTotalOut = length(outputDirection);
descriptionsH = cell( nDofsTotalOut, nDofsTotalIn);

iIn=0;iOut=0;

for iOutDir = 1 : length(outputDirection)
    iOut = iOut + 1;
    iIn = 0;
    
    for iInDir = 1 : length(inputDirection)
        iIn = iIn + 1;
        
        
        currInputDirection = inputDirection(iInDir);
        currOutputDirection = outputDirection(iOutDir);
        
        inPosStr = num2str( sensorIn.position*1e3 , '%3.0f' );
        inDirStr = ldof(currInputDirection);
        
        outPosStr = num2str( sensorOut.position*1e3 , '%3.0f' );
        outDirStr = ldof(currOutputDirection);
        
        descriptionsH{iOut,iIn} = ['in',inPosStr,inDirStr,' out',outPosStr,outDirStr];
        
    end
    
end


obj.descriptionsH = descriptionsH;
end