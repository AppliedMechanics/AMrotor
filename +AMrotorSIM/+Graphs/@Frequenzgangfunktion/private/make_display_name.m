function DisplayName = make_display_name(obj,inputLocDof,outputLocDof)
objFRF = obj.experimentFRF;
dofPerNode = 6;

inputLocDir = mod(inputLocDof,dofPerNode);
inputLocNodeNo = floor((inputLocDof-1)/dofPerNode)+1;
outputLocDir = mod(outputLocDof,dofPerNode);
outputLocNodeNo = floor((outputLocDof-1)/dofPerNode)+1;

dof_name = {'X','Y','Z','PSIX','PSIY','PSIZ'};
dof_loc = [1,2,3,4,5,0];
ldof = containers.Map(dof_loc,dof_name);

inPosStr = num2str(objFRF.inputPosition(inputLocNodeNo)*1e3,'%3.0f');
inDirStr = ldof(inputLocDir);

outPosStr = num2str(objFRF.outputPosition(outputLocNodeNo)*1e3,'%3.0f');
outDirStr = ldof(outputLocDir);

DisplayName = ['in',inPosStr,inDirStr,' out',outPosStr,outDirStr];
end